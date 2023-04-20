
import time
import boto3
import json
import os
import gzip
import io
from botocore.exceptions import ClientError

from urllib.parse import unquote_plus
import functions_definitions as my

import logging
logger = logging.getLogger()

logger.setLevel(logging.INFO)

destination_bucket_name_verified = os.environ["DESTINATION_BUCKET_NAME_VERIFIED"]
destination_bucket_name_dirty = os.environ["DESTINATION_BUCKET_NAME_DIRTY"]
FINAL_OUTPUTS_FOLDER = os.environ["FINAL_OUTPUTS_FOLDER"]


def lambda_handler(event, context):
    record = event["detail"]
    s3bucket = record['bucket']['name']
    s3object = unquote_plus(record['object']['key'])
    s3resource = boto3.resource('s3')
    s3client = boto3.client('s3')

    # loading the content of GZ file
    content_object = s3resource.Object(s3bucket, s3object)
    file_content = content_object.get()['Body'].read()
    with gzip.GzipFile(fileobj=io.BytesIO(file_content), mode='rb') as fh:
        content_json = fh.read().decode('utf8')
    # Split the multiple JSON object exist in the same file - every line is related to single S3 object
    lines = content_json.split('\n')

    for line in lines:
        if line != '':
            # convert to JSON object
            data = json.loads(line)
            # retrieving the object information
            finding_severity_desc = data["severity"]["description"]
            finding_bucket = data["resourcesAffected"]["s3Bucket"]["name"]
            finding_file = data["resourcesAffected"]["s3Object"]["key"]
            # generating the related file names which needs to be
            related_file = finding_file.split('/')[-1]
            related_file_final = FINAL_OUTPUTS_FOLDER + "/" + \
                related_file.replace("full_transcript", "final_output")
            target_file = finding_file.split(
                '.')[0] + "_verified." + finding_file.split('.')[1]
            target_file_final = related_file_final.split(
                '.')[0] + "_verified." + related_file_final.split('.')[1]

            # constructing the source objects
            copy_source_object = {
                'Bucket': finding_bucket, 'Key': finding_file}
            copy_source_object_final = {
                'Bucket': finding_bucket, 'Key': related_file_final}

            ########################################################################
            # attempt to move the file - if its not a hidden file
            if finding_severity_desc == 'Informational' and not finding_file.startswith('.', 0, 1):

                # copy the file to "Verified Clean"
                my.s3_copy_object(s3client, copy_source_object,
                                  destination_bucket_name_verified, target_file)
                my.s3_copy_object(s3client, copy_source_object_final,
                                  destination_bucket_name_verified, target_file_final)
            elif finding_severity_desc == 'Medium' or finding_severity_desc == 'High' or finding_severity_desc == 'Low':

                # Attempt to copy the file into dirty bucket
                my.s3_copy_object(s3client, copy_source_object,
                                  destination_bucket_name_dirty, target_file)

                my.s3_copy_object(s3client, copy_source_object_final,
                                  destination_bucket_name_dirty, target_file_final)
            # Doing the S3 files clean up in our buckets
            my.s3_clean_up(s3client, finding_bucket, finding_file)
