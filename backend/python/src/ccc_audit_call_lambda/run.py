import os
import boto3
import uuid
import status_list
import buckets
import folders
import logging
import json
from datetime import datetime

s3 = boto3.resource("s3")
logger = logging.getLogger()

if os.environ['DEBUG'] == 'enabled':
    logger.setLevel(logging.DEBUG)

else:
    if os.environ['ENV'] == 'prd':
        logger.setLevel(logging.ERROR)
    elif os.environ['ENV'] == 'qa':
        logger.setLevel(logging.WARNING)
    else:
        # for dev
        logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("Event: " + json.dumps(event))

    # Get bucket and file name details
    bucket = event['detail']['bucket']['name']
    key = event['detail']['object']['key']

    logger.info("Bucket: " + bucket)

    folder = os.path.dirname(key)
    file = os.path.basename(key)
    file_ext = os.path.splitext(file)[1]


    if folder:
        path = bucket + '/' + folder + '/'
    else:
        path = bucket

    # Create a DynamoDB client
    dynamodb = boto3.resource("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    table = dynamodb.Table(table_name)

    # Create random UUID
    id = str(uuid.uuid4())

    split_file = file.split('_')
    if file_ext not in ('.wav', '.txt', '.json'):
        if len(split_file) > 1:
            # handling a typical metadata file
            split_file = file.split('_')
            call_type = split_file[1]
            file_id = "0"
        else:
            # handling a non-typical metadata file
            call_type = "0"
            file_id = "0"            
    else:
        # handling a typical NLA file
        if len(split_file) > 1:
            call_type = split_file[1]
            file_id = split_file[2]
        else:
            # handling a non-typical NLA file
            call_type = "0"
            file_id = "0"

    status = ""

    logger.info("Path: " + path)

    if path == buckets.UNREFINED:
        status = status_list.AUDIO_FILE_RECEIVED
    elif path == buckets.TRANSCRIPTION + "/" + folders.STANDARD + "/":
        status = status_list.AUDIO_TRANSCRIPT_WITHSPEAKERLABEL_GENERATED
    elif path == buckets.TRANSCRIPTION + "/" + folders.STANDARD_FULL_TRANSCRIPTS + "/":
        status = status_list.TRANSCRIPT_SIMPLETEXT_WITHPII_GENERATED
    elif path == buckets.CLEANED + "/" + folders.STANDARD_FULL_TRANSCRIPTS + "/":
        status = status_list.TRANSCRIPT_SIMPLETEXT_NOPII_GENERATED
    elif path == buckets.CLEANED + "/" + folders.FINAL_OUTPUTS + "/":
        status = status_list.FINAL_INDENTED_OUTPUT_GENERATED
    elif path == buckets.CLEANED + "/" + folders.FINAL_OUTPUTS2 + "/":
        status = status_list.FINAL_NONINDENTED_OUTPUT_GENERATED
    elif path == buckets.CLEANED_VERIFIED + "/" + folders.STANDARD_FULL_TRANSCRIPTS + "/":
        status = status_list.STANDARD_FULL_TRANSCRIPT_CLEANED_VERIFIED
    elif path == buckets.CLEANED_VERIFIED + "/" + folders.FINAL_OUTPUTS + "/":
        status = status_list.FINAL_VERIFIED_INDENTED_OUTPUT_GENERATED
    elif path == buckets.CLEANED_VERIFIED + "/" + folders.FINAL_OUTPUTS2 + "/":
        status = status_list.FINAL_VERIFIED_NONINDENTED_OUTPUT_GENERATED
    elif path == buckets.DIRTY:
        status = status_list.STANDARD_FULL_TRANSCRIPT_DIRTY_VERIFIED
    elif path == buckets.RECORDINGS + "/" + folders.EDIX_AUDIO + "/":
        status = status_list.AUDIO_RECORDINGS_FILE_UPLOADED
    elif path == buckets.RECORDINGS + "/" + folders.EDIX_METADATA + "/":
        status = status_list.METADATA_RECORDINGS_FILE_UPLOADED
    elif path == buckets.METADATA:
        status = status_list.METADATA_FILE_UPLOADED
    elif path == buckets.AUDIO:
        status = status_list.AUDIO_FILE_UPLOADED
    else:
        logger.info("Not a valid bucket to audit")
        return
    
    now = datetime.now()
    # dd/mm/YY H:M:S
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
    
    logger.info("Auditing status -" + status + " for file - " + file + " at  - " + dt_string)

    response = table.put_item(
        Item={"UUID": id, "CallType": call_type, "FileID": file_id, "Path": path, "FileName": file, "Status": status,
              "DateTimeStamp": dt_string})

    logger.info(response)