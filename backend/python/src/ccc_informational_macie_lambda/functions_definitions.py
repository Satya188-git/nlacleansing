
from botocore.exceptions import ClientError
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

source_bucket_name_unrefined = os.environ["UNREFINED_BUCKET_NAME"]
source_bucket_name_cleaned = os.environ["CLEANED_BUCKET_NAME"]


def s3_clean_up(s3client, source_bucket_name, file_key_name):

    ##########################################################################
    #                           cleaning up                                  #
    ##########################################################################

    if "_wav_standard_cleaned.txt" in file_key_name:
        logger.info(file_key_name)
    else:
        logger.info(file_key_name)

    # delete the file from Cleaned bucket "standard_full_transcripts/"
    try:
        response = s3client.delete_object(
            Bucket=source_bucket_name_cleaned,
            Key=file_key_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)


# ---------------------------------------------------------------#

def s3_copy_object(s3client, copy_source_object, destination_bucket_name, target_file):

    try:
        response = s3client.copy_object(
            CopySource=copy_source_object,
            Bucket=destination_bucket_name,
            Key=target_file
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)
