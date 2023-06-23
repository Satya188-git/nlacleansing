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
        recent_audio_files = get_recent_files(call_recordings_bucket, edix_audio_dir)
        copycount=0
        existingdeletecount=0
        
        for fileObject in recent_audio_files:
            try:
                if( check_file_exists(  audio_bucket,  fileObject['object_name']  ) ):
                    s3_object = s3.get_object(Bucket=audio_bucket, Key=fileObject['object_name'])
                    source_key = edix_audio_dir+'/'+fileObject['object_name']
                    
                    # Compare the size of the object in bytes.
                    if( fileObject['object_size'] > s3_object['ContentLength']) :
                        copycount=copycount + 1
                        logger.info("File copy count : " + str(copycount))
                        move_file(call_recordings_bucket, source_key, audio_bucket, fileObject['object_name'])
                    else:
                        existingdeletecount = existingdeletecount + 1
                        logger.info("File existing delete count : "+  str(existingdeletecount))
                        logger.info(f"File '{fileObject['object_name']}' with same or larger size already exist in bucket '{audio_bucket}'.")     
                        s3.delete_object(Bucket=call_recordings_bucket, Key=source_key)
                        logger.info(f"File deleted from '{call_recordings_bucket}/{source_key}'.")
                else:
                    copycount=copycount + 1
                    logger.info("File copy count : " + str(copycount))
                    move_file(call_recordings_bucket, edix_audio_dir+'/'+fileObject['object_name'], audio_bucket, fileObject['object_name'])
            except Exception as e:
                errorMessage = str(e)
                logger.error(fileObject)
                logger.error(errorMessage)        
    except Exception as e:
        errorMessage = str(e)
        logger.error(errorMessage)
        return {
            'errorMessage': errorMessage
        }
    
def get_recent_files(bucket_name, folder_prefix):
    # Generate file_list
    paginator = s3.get_paginator('list_objects_v2')
    page_iterator = paginator.paginate(Bucket=bucket_name,Prefix=folder_prefix)

    all_objects = []
    for page in page_iterator:
        if 'Contents' in page:
            all_objects.extend(page['Contents'])
    recent_files = []
    for obj in all_objects:
        if len(obj['Key'].split(folder_prefix+'/')[1]) > 0: # Ignoring subfolder item
            recentobject = '{"object_name":"' + obj['Key'].split(folder_prefix+'/')[1] +'" , "object_size" : ' + str(obj['Size']) + "}"
            recent_files.append(json.loads(recentobject))    
    logger.info(recent_files)
    logger.info('current file count : ' + str(len(recent_files)))
    return recent_files

def check_file_exists(target_bucket, target_key):
    try:
        s3.head_object(Bucket=target_bucket, Key=target_key)
        return True
    except Exception as e:
        return False

def move_file(source_bucket, source_key, destination_bucket, destination_key):
    copy_source = {
        'Bucket': source_bucket,
        'Key': source_key
    }
    s3.copy(copy_source, destination_bucket, destination_key)
    logger.info(f"File copied from '{source_bucket}/{source_key}' to '{destination_bucket}/{destination_key}'.")
    # Delete the original object
    s3.delete_object(Bucket=source_bucket, Key=source_key)
    logger.info(f"File deleted from '{source_bucket}/{source_key}'.")
