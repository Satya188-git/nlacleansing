import boto3
import logging

s3 = boto3.client('s3')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    source_bucket = event['source_bucket']
    destination_bucket = event['destination_bucket']
    keys_to_copy = event['keys_to_copy']
    delete_marker = event['delete_marker']
    destination_prefix = event['destination_prefix']
    source_prefix = event['source_prefix']
    for key in keys_to_copy:
        try:
            # Create the destination key by combining the destination prefix with the file name
            destination_key = destination_prefix + key.split('/')[-1]
            source_key = source_prefix + key.split('/')[-1]
            # Copy object to the destination bucket
            s3.copy_object(CopySource={'Bucket': source_bucket, 'Key': source_key}, Bucket=destination_bucket, Key=destination_key)
            logger.info(f"file{source_key} copied to {destination_key}")
            
              ##delete_marker = input(f" Do you want to delete {key} from {source_bucket}? (yes/no):")
            
            if delete_marker.lower() == 'yes':
                s3.delete_object(Bucket=source_bucket, Key=source_key)
                
                logger.info(f"File{source_key} deleted from source_bucket")

                
        except Exception as e:
                logger.error(f"Error deleting file:{str(e)}")
            
        