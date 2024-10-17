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
    validated_bucket=validate_bucket(bucket)['validated_bucket']

    key = event['detail']['object']['key']
    validated_key=validate_key(key)['validated_key']

    logger.debug("Bucket: " + validated_bucket)
    logger.debug("Key: " + validated_key)

    folder = os.path.dirname(validated_key)
    logger.debug(folder)
    file = os.path.basename(validated_key)
    logger.debug(file)
    file_ext = os.path.splitext(file)[1]
    logger.debug(file_ext)

    if folder:
        path = validated_bucket + '/' + folder + '/'
    else:
        path = validated_bucket
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
    
    if event['source']=='aws.lambda':
        status = event['detail']['status']
        validated_status=validate_status(status)['validated_status']
    else:
        if path == buckets.UNREFINED:
            validated_status = status_list.AUDIO_FILE_RECEIVED
        elif path == buckets.TRANSCRIPTION + "/" + folders.STANDARD + "/":
            validated_status = status_list.AUDIO_TRANSCRIPT_WITHSPEAKERLABEL_GENERATED
        elif path == buckets.TRANSCRIPTION + "/" + folders.STANDARD_FULL_TRANSCRIPTS + "/":
            validated_status = status_list.TRANSCRIPT_SIMPLETEXT_WITHPII_GENERATED
        elif path == buckets.CLEANED + "/" + folders.STANDARD_FULL_TRANSCRIPTS + "/":
            validated_status = status_list.TRANSCRIPT_SIMPLETEXT_NOPII_GENERATED
        elif path == buckets.CLEANED + "/" + folders.FINAL_OUTPUTS + "/":
            validated_status = status_list.FINAL_INDENTED_OUTPUT_GENERATED
        elif path == buckets.CLEANED + "/" + folders.FINAL_OUTPUTS2 + "/":
            validated_status = status_list.FINAL_NONINDENTED_OUTPUT_GENERATED
        elif path == buckets.CLEANED_VERIFIED + "/" + folders.STANDARD_FULL_TRANSCRIPTS + "/":
            validated_status = status_list.STANDARD_FULL_TRANSCRIPT_CLEANED_VERIFIED
        elif path == buckets.CLEANED_VERIFIED + "/" + folders.FINAL_OUTPUTS + "/":
            validated_status = status_list.FINAL_VERIFIED_INDENTED_OUTPUT_GENERATED
        elif path == buckets.CLEANED_VERIFIED + "/" + folders.FINAL_OUTPUTS2 + "/":
            validated_status = status_list.FINAL_VERIFIED_NONINDENTED_OUTPUT_GENERATED
        elif path == buckets.DIRTY:
            validated_status = status_list.STANDARD_FULL_TRANSCRIPT_DIRTY_VERIFIED
        elif path == buckets.RECORDINGS + "/" + folders.EDIX_AUDIO + "/":
            validated_status = status_list.AUDIO_RECORDINGS_FILE_UPLOADED
        elif path == buckets.RECORDINGS + "/" + folders.EDIX_METADATA + "/":
            validated_status = status_list.METADATA_RECORDINGS_FILE_UPLOADED
        elif path == buckets.METADATA + "/" + folders.EDIX_METADATA + "/":
            validated_status = status_list.METADATA_FILE_UPLOADED
        elif path == buckets.AUDIO:
            validated_status = status_list.AUDIO_FILE_UPLOADED
        else:
            logger.info("Not a valid bucket to audit")
            return
    
    now = datetime.now() 
    dt_number=int(now.strftime("%Y%m%d%H%M%S%f"))

    is_valid, message = validate_inputs(call_type_number,dt_number,file_id)

    if is_valid:
        response = table.put_item(
            Item={"callType": call_type_number, "callId": int(file_id), "path": path, "fileName": file, "status": validated_status,"datetimeStamp": dt_number})
        logger.debug(response)
        
        logger.info("Audited status - " + validated_status + " - for file - " + file + " - at - " + str(dt_number))  
    else:
        logger.info("Input validation failed",message)  
        raise ValueError(message)  


##### function to validate inputs inserting into database
def validate_inputs(call_type_number,dt_number,file_id):
    ##validation to check call_type_number
    if not (isinstance(call_type_number, int) and len(str(call_type_number)) == 7):
        return False, f"Invalid callType input! Expected a 7-digit integer, got '{call_type_number}'."

    ##validation to check dt_number
    if not (isinstance(dt_number, int)):
        return False, f"Invalid datetimestamp input! Expected integer, got '{dt_number}'."
    
    ##validation to check file_id
    file_id_int=int(file_id)
    if not (isinstance(file_id_int, int)):
        return False, f"Invalid CallId input! Expected integer, got '{file_id_int}'."

    return True, "All inputs are valid!"

#####function to validate the bucket name getting from event 
def validate_bucket(bucket):
    if not isinstance(bucket, str):
        raise ValueError("Invalid input: bucket value must be a string")
    else:
        validated_bucket = bucket
        return {
                'validated_bucket':bucket
                }

#####function to validate the key getting from event 
def validate_key(key):
    if not isinstance(key, str):
        raise ValueError("Invalid input: key value must be a string")
    else:
        validated_key = key
        return {
                'validated_key':key
                }
#####function to validate the key getting from event 
def validate_status(status):
    if not isinstance(status, str):
        raise ValueError("Invalid input: bucket value must be a string")
    else: 
        validated_status=status
        return {
            'validated_status':status
            }
    
    