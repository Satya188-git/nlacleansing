
from botocore.exceptions import ClientError
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

source_bucket_name_unrefined = os.environ["UNREFINED_BUCKET_NAME"]
source_bucket_name_transcription = os.environ["TRANSCRIPTION_BUCKET_NAME"]


def s3_clean_up(s3client, source_bucket_name, file_key_name):

    ##########################################################################
    #                           cleaning up                                  #
    ##########################################################################

    unrefined_file_name = file_key_name

    if "_wav_standard_cleaned.txt" in file_key_name:
        unrefined_file_name = unrefined_file_name.replace(
            '_wav_standard_cleaned.txt', '.wav')

    logger.info("unrefined_file_name is :", unrefined_file_name)

    full_transcription_file_name = file_key_name
    transcription_standard_file_name = file_key_name
    if "_wav_standard_cleaned.txt" in file_key_name:
        full_transcription_file_name = full_transcription_file_name.replace(
            '_wav_standard_cleaned.txt', '_wav_standard.txt')
        transcription_standard_file_name = transcription_standard_file_name.replace(
            '_wav_standard_cleaned.txt', '_wav_standard.json')
    else:
        print("Unsupported File Format")

    # delete the file from CLEANED bucket
    try:
        response = s3client.delete_object(
            Bucket=source_bucket_name,
            Key=file_key_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)

    # delete the file from UNREFINED bucket
    try:
        response = s3client.delete_object(
            Bucket=source_bucket_name_unrefined,
            Key=unrefined_file_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)

    # delete the file from TRANSCRIPTION bucket "standard/"
    try:
        response = s3client.delete_object(
            Bucket=source_bucket_name_transcription,
            Key="standard/" + transcription_standard_file_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)
        # exit(1)

    # delete the file from TRANSCRIPTION bucket "standard_full_transcripts/"
    try:
        response = s3client.delete_object(
            Bucket=source_bucket_name_transcription,
            Key="standard_full_transcripts/" + full_transcription_file_name
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
