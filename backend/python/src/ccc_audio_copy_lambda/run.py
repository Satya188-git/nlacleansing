import os
import boto3
import logging
import json
from datetime import datetime, timedelta
from dateutil import tz

s3 = boto3.client("s3")
logger = logging.getLogger()
audio_bucket = os.environ['AUDIO_BUCKET']
call_recordings_bucket = os.environ['CALL_RECORDINGS_BUCKET']
edix_audio_dir = os.environ['EDIX_AUDIO_DIR']

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
    try:
        audio_files = get_recent_files(call_recordings_bucket, edix_audio_dir)
        for fileObjectKey in audio_files:
            copy_file(call_recordings_bucket, fileObjectKey, audio_bucket, fileObjectKey)
    except Exception as e:
        errorMessage = str(e)
        logger.error(errorMessage)
        return {
            'errorMessage': errorMessage
        }
    
def get_recent_files(bucket_name, folder_prefix):
    # Calculate the timestamp for x minutes ago
    minutes_ago = datetime.now(tz.UTC) - timedelta(minutes=5)

    # Get bucket and file name
    response = s3.list_objects_v2(Bucket=bucket_name, Prefix=folder_prefix)
    logger.info(response)

    # Filter files based on the LastModified timestamp
    recent_files = []
    for obj in response['Contents']:
        last_modified = obj['LastModified'].astimezone(tz.UTC)
        if last_modified > minutes_ago:
            recent_files.append(obj['Key'])

    logger.info(recent_files)
    return recent_files

def copy_file(source_bucket, source_key, destination_bucket, destination_key):
    copy_source = {
        'Bucket': source_bucket,
        'Key': source_key
    }
    destFileObjectKey = os.path.basename(destination_key)
    s3.copy(copy_source, destination_bucket, destFileObjectKey)
    logger.info(f"File copied from '{source_bucket}/{source_key}' to '{destination_bucket}/{destFileObjectKey}'.")


       