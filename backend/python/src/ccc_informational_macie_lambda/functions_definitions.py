
from botocore.exceptions import ClientError
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


# Defining the source bucket names:
source_bucket_name_unrefined = 'customercallcenterpiiunrefined'
source_bucket_name_transcription = 'customercallcenterpiitranscription'
# we will also do clean up in the "cleaned" bucket, which its name will be passed to s3_clean_up fuction.


def s3_clean_up(s3client, source_bucket_name, file_key_name):

    # print("Original File name:", file_key_name)
    ##########################################################################
    #                           cleaning up                                  #
    ##########################################################################

    # cleaned file name:   InnPOC_EBHB_1245656_6968917624718701096_Summed_wav_standard_cleaned.txt
    # unrefined file name: InnPOC_EBHB_1245656_6968917624718701096_Summed.wav
    unrefined_file_name = file_key_name

    if "_wav_standard_cleaned.txt" in file_key_name:
        unrefined_file_name = unrefined_file_name.replace(
            '_wav_standard_cleaned.txt', '.wav')
    elif "_wav_callanalytics_cleaned.txt" in file_key_name:
        unrefined_file_name = unrefined_file_name.replace(
            '_wav_callanalytics_cleaned.txt', '.wav')

    # print("Unrefined file:", unrefined_file_name)

    # cleaned file name:        InnPOC_EBHB_1245656_6968917624718701096_Summed_wav_standard_cleaned.txt
    #                 analytics/InnPOC_EBHB_1245656_6968917624718701096_Summed_wav_callanalytics.json
    # standard_full_transcripts/InnPOC_EBHB_1245656_6968917624718701096_Summed_wav_standard.txt
    #                  standard/InnPOC_EBHB_1245656_6968917624718701096_Summed_wav_standard.json

    full_transcription_file_name = file_key_name
    transcription_standard_file_name = file_key_name
    transcription_callanalytics_file_name = file_key_name
    if "_wav_standard_cleaned.txt" in file_key_name:
        full_transcription_file_name = full_transcription_file_name.replace(
            '_wav_standard_cleaned.txt', '_wav_standard.txt')
        transcription_standard_file_name = transcription_standard_file_name.replace(
            '_wav_standard_cleaned.txt', '_wav_standard.json')
        transcription_callanalytics_file_name = transcription_callanalytics_file_name.replace(
            '_wav_standard_cleaned.txt', '_wav_callanalytics.json')
    elif "_wav_callanalytics_cleaned" in file_key_name:
        full_transcription_file_name = full_transcription_file_name.replace(
            '_wav_callanalytics_cleaned.txt', '_wav_standard.txt')
        transcription_standard_file_name = transcription_file_name.replace(
            '_wav_callanalytics_cleaned.txt', '_wav_standard.json')
        transcription_callanalytics_file_name = transcription_callanalytics_file_name.replace(
            '_wav_callanalytics_cleaned.txt', '_wav_callanalytics.json')

    # print("Transcription file:", transcription_file_name)
    # print("Full Transcription file:", full_transcription_file_name)

    # delete the file from CLEANED bucket
    try:
        print("test1")
        response = s3client.delete_object(
            Bucket=source_bucket_name,
            Key=file_key_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)
        # exit(1)

    # delete the file from UNREFINED bucket
    try:
        print("test2")
        response = s3client.delete_object(
            Bucket=source_bucket_name_unrefined,
            Key=unrefined_file_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)
        # exit(1)

    # delete the file from TRANSCRIPTION bucket "analytics/"

    # print("bucket:", source_bucket_name_transcription)
    # print("file name to delete:", "standard/" + transcription_standard_file_name)
    # print("file name to delete:", "analytics/" + transcription_callanalytics_file_name)
    # print("Oroginal file name passed:", file_key_name)

    try:
        print("test3")
        response = s3client.delete_object(
            Bucket=source_bucket_name_transcription,
            Key="analytics/" + transcription_callanalytics_file_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)
        # exit(1)

    # delete the file from TRANSCRIPTION bucket "standard/"
    try:
        print("test4")
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
        print("test5")
        response = s3client.delete_object(
            Bucket=source_bucket_name_transcription,
            Key="standard_full_transcripts/" + full_transcription_file_name
        )
        logger.info(response)
    except ClientError as ex:
        logger.error(ex)
        # exit(1)


# ---------------------------------------------------------------#

def s3_copy_object(s3client, copy_source_object, destination_bucket_name, target_file):

    try:
        response = s3client.copy_object(
            CopySource=copy_source_object,
            Bucket=destination_bucket_name,
            Key=target_file
        )
        # logger.info(response)
    except ClientError as ex:
        print("error")
        print(copy_source_object)
        print(destination_bucket_name)
        print(target_file)
        logger.error(ex)
        # exit(1)
