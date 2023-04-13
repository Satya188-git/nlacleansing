
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


# destination_bucket_name_verified = 'customercallcenterpiicleanedverified'
# destination_bucket_name_dirty = 'customercallcenterpiidirty'
destination_bucket_name_verified = os.environ["DESTINATION_BUCKET_NAME_VERIFIED"]
destination_bucket_name_dirty = os.environ["DESTINATION_BUCKET_NAME_DIRTY"]
FINAL_OUTPUTS_FOLDER = os.environ["FINAL_OUTPUTS_FOLDER"]


def lambda_handler(event, context):

    print(event)

    # Extracting the bucket & file name
    record = event['Records'][0]
    s3bucket = record['s3']['bucket']['name']
    s3object = unquote_plus(record['s3']['object']['key'])
    print("Bucket Name: ", s3bucket)
    print("Object Name: ", s3object)

    # Creating clients
    s3resource = boto3.resource('s3')
    s3client = boto3.client('s3')

    # loading the content of GZ file
    content_object = s3resource.Object(s3bucket, s3object)
    file_content = content_object.get()['Body'].read()
    print("file_content")
    print(file_content)
    with gzip.GzipFile(fileobj=io.BytesIO(file_content), mode='rb') as fh:
        content_json = fh.read().decode('utf8')
        print("content_json")
        print(content_json)
    # Split the multiple JSON object exist in the same file - every line is related to single S3 object
    lines = content_json.split('\n')

    print("Number of files to be processed:", len(lines))

    for line in lines:

        if line != '':

            # convert to JSON object
            data = json.loads(line)
            print("********data*************")
            print(data)
            # retrieving the object information
            finding_severity_desc = data["severity"]["description"]
            finding_bucket = data["resourcesAffected"]["s3Bucket"]["name"]
            # standard_full_transcripts/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_full_transcript_cleaned.json
            finding_file = data["resourcesAffected"]["s3Object"]["key"]

            # if finding_severity_desc != 'Informational':
            print("finding_severity_desc: ",
                  finding_severity_desc)  # Informational
            print("finding_bucket: ", finding_bucket)  # cccpiicleanedpoc
            # standard_full_transcripts/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_full_transcript_cleaned.json
            print("finding_file: ", finding_file)

            # generating the related file names which needs to be
            related_file = finding_file.split('/')[-1]
            related_file_final = FINAL_OUTPUTS_FOLDER + "/" + \
                related_file.replace("full_transcript", "final_output")
            # related_file_final2 = "final_outputs2/" + \
            #     related_file.replace("full_transcript", "final_output")
            # related_file_standard = "standard/" + related_file.replace("full_transcript_", "")

            # Related File:  NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_full_transcript_cleaned.json
            print("Related File: ", related_file)
            # final_outputs/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_final_output_cleaned.json
            print("Related File Final: ", related_file_final)
            # final_outputs2/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_final_output_cleaned.json
            # print("Related File Final2: ", related_file_final2)
            # print("Related File Standard: ", related_file_standard)   #  standard/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_cleaned.json

            # generating the target file name
            # standard_full_transcripts/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_full_transcript_cleaned_verified.json
            target_file = finding_file.split(
                '.')[0] + "_verified." + finding_file.split('.')[1]
            # final_outputs/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_final_output_cleaned_verified.json
            target_file_final = related_file_final.split(
                '.')[0] + "_verified." + related_file_final.split('.')[1]
            # final_outputs2/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_final_output_cleaned_verified.json
            # target_file_final2 = related_file_final2.split(
            #     '.')[0] + "_verified." + related_file_final2.split('.')[1]

            # target_file_standard = related_file_standard.split('.')[0] + "_verified." + related_file_standard.split('.')[1]  # standard/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_cleaned_verified.json

            print("target_file: ", target_file)
            print("target_file Final: ", target_file_final)
            # print("target_file Final: ", target_file_final2)
            # print("target file Standard: ", target_file_standard)

            # constructing the source objects
            copy_source_object = {
                'Bucket': finding_bucket, 'Key': finding_file}
            print("1 *************")
            # {'Bucket': 'cccpiicleanedpoc', 'Key': 'standard_full_transcripts/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_full_transcript_cleaned.json'}
            print(copy_source_object)
            copy_source_object_final = {
                'Bucket': finding_bucket, 'Key': related_file_final}
            print("2 *************")
            # {'Bucket': 'cccpiicleanedpoc', 'Key': 'final_outputs/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_final_output_cleaned.json'}
            # print(copy_source_object_final)
            # copy_source_object_final2 = {
            #     'Bucket': finding_bucket, 'Key': related_file_final2}
            # print("3 *************")
            # # {'Bucket': 'cccpiicleanedpoc', 'Key': 'final_outputs2/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_final_output_cleaned.json'}
            # print(copy_source_object_final2)
            # # copy_source_object_standard = {'Bucket': finding_bucket, 'Key': related_file_standard}
            # print("4 *************")
            # print(copy_source_object_standard) # {'Bucket': 'cccpiicleanedpoc', 'Key': 'standard/NLA_EBHB_1245602_7150364831740142348_Summed_wav_standard_cleaned.json'}

            ########################################################################
            # attempt to move the file - if its not a hidden file
            if finding_severity_desc == 'Informational' and not finding_file.startswith('.', 0, 1):

                # copy the file to "Verified Clean"
                my.s3_copy_object(s3client, copy_source_object,
                                  destination_bucket_name_verified, target_file)
                print("5 *************")
                my.s3_copy_object(s3client, copy_source_object_final,
                                  destination_bucket_name_verified, target_file_final)
                # print("6*************")
                # my.s3_copy_object(s3client, copy_source_object_final2,
                #                   destination_bucket_name_verified, target_file_final2)
                print("7 *************")
                # my.s3_copy_object(s3client, copy_source_object_standard, destination_bucket_name_verified, target_file_standard)
                print("8 *************")

            elif finding_severity_desc == 'Medium' or finding_severity_desc == 'High' or finding_severity_desc == 'Low':

                # Attempt to copy the file into dirty bucket
                my.s3_copy_object(s3client, copy_source_object,
                                  destination_bucket_name_dirty, target_file)
                print("9 *************")
                my.s3_copy_object(s3client, copy_source_object_final,
                                  destination_bucket_name_dirty, target_file_final)
                # print("10 *************")
                # my.s3_copy_object(s3client, copy_source_object_final2,
                #                   destination_bucket_name_dirty, target_file_final2)
                print("11 *************")
                # my.s3_copy_object(s3client, copy_source_object_standard, destination_bucket_name_dirty, target_file_standard)
                print("12 *************")

            # Doig the S3 files clean up in our buckets
            print("13 *************")
            my.s3_clean_up(s3client, finding_bucket, finding_file)
            print("14 *************")
