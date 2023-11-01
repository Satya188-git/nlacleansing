import os
import boto3
import status_list
import buckets
import folders
import logging
import json
from datetime import datetime

s3 = boto3.resource("s3")

debug = os.environ['DEBUG']

logger = logging.getLogger()
if (debug == 'enabled'):
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Event: " + json.dumps(event))
    
    # Read the calltypes JSON file
    with open('calltypes.json', 'r') as file:
        calltype_data = json.load(file)
    
    # Get bucket and file name details
    bucket = event['detail']['bucket']['name']
    key = event['detail']['object']['key']

    logger.debug("Bucket: " + bucket)

    folder = os.path.dirname(key)
    logger.debug(folder)
    file = os.path.basename(key)
    logger.debug(file)
    file_ext = os.path.splitext(file)[1]
    logger.debug(file_ext)

    if folder:
        path = bucket + '/' + folder + '/'
    else:
        path = bucket
    # Create a DynamoDB client
    dynamodb = boto3.resource("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    table = dynamodb.Table(table_name)

    split_file = file.split('_')
    if file_ext not in ('.wav', '.txt', '.json'):
        if len(split_file) > 1:
            # handling a typical metadata CSV file
            split_file = file.split('_')
            call_type = split_file[1]
            logger.debug("call_type : " + call_type)
            call_type_number = calltype_data[call_type]
            logger.debug(call_type_number)
            file_id = 0
        else:
            # handling a non-typical metadata CSV file
            call_type = 0
            file_id = 0            
    else:
        # handling a typical NLA file
        if len(split_file) > 1:
            call_type_number = int(split_file[1])
            logger.debug(call_type_number)
            file_id = split_file[2]
        else:
            # handling a non-typical NLA file
            call_type = 0
            file_id = 0

    status = ""

    logger.info("Path : " + path)

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
    elif path == buckets.METADATA + "/" + folders.EDIX_METADATA + "/":
        status = status_list.METADATA_FILE_UPLOADED
    elif path == buckets.AUDIO:
        status = status_list.AUDIO_FILE_UPLOADED
    else:
        logger.info("Not a valid bucket to audit")
        return
    
    now = datetime.now() 
    dt_number=int(now.strftime("%Y%m%d%H%M%S%f"))

    response = table.put_item(
        Item={"callType": call_type_number, "callId": int(file_id), "path": path, "fileName": file, "status": status,"datetimeStamp": dt_number})
    logger.debug(response)
    
    logger.info("Audited status - " + status + " - for file - " + file + " - at - " + str(dt_number))    