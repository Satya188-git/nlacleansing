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


def lambda_handler(event, context):
    logger.info("Event: " + json.dumps(event))

    # Get bucket and file name
    bucket = event['detail']['bucket']['name']
    key = event['detail']['object']['key']

    logger.info("Bucket: " + bucket)

    folder = os.path.dirname(key)
    file = os.path.basename(key)
    file_ext = os.path.splitext(file)[1]

    if file_ext not in ('.wav', '.txt', '.json'):
        quit()

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
    call_type = split_file[1]
    file_id = split_file[2]

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

    now = datetime.now()
    # dd/mm/YY H:M:S
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

    table.put_item(
        Item={"UUID": id, "CallType": call_type, "FileID": file_id, "Path": path, "FileName": file, "Status": status,
              "DateTimeStamp": dt_string})
