import json
import boto3
import logging

s3 = boto3.client("s3")
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        bucket_name = event["bucket"]
        file_name = event["file"]
        copy_source = {
            'Bucket': bucket_name,
            'Key': file_name
        }
        if 'EDIX_METADATA' in file_name:
            destination_bucket = 'sdge-dtdes-dev-wus2-s3-nla-callrecordings'
            destFileObjectKey = file_name
        else:
            destination_bucket = 'sdge-dtdes-dev-wus2-s3-nla-callrecordings'
            destFileObjectKey = 'EDIX_AUDIO/' + file_name
        
        s3.copy(copy_source, destination_bucket, destFileObjectKey)
        logger.info(f"File is copied from '{bucket_name}/{file_name}' to '{destination_bucket}/{destFileObjectKey}'.")
        
        s3.delete_object(Bucket=bucket_name, Key=file_name)
        logger.info(f"File deleted from '{bucket_name}/{file_name}'.")
        
    except Exception as e:
        logger.info(e)

'''
Role - Audio-Copy-Role
FileTestEvent-
{
  "bucket": "sdge-dtdes-dev-wus2-s3-nla-unrefined",
  "file": "NLA_1245624_7376977128867301215_Summed.wav"
}
MetadataTestEvent-
{
  "bucket": "sdge-dtdes-dev-wus2-s3-nla-pii-metadata",
  "file": "EDIX_METADATA/NLA_ERMyAcctInq_2023-10-23.csv"
}
'''