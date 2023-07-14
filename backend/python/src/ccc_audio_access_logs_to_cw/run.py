import boto3
from datetime import datetime
from dateutil import tz
import logging
import os

def lambda_handler(event, context):
    print(event)
    # Retrieve the S3 bucket and object key from the event
    s3_bucket = event['detail']['bucket']['name']
    s3_key = event['detail']['object']['key']
    print (s3_bucket)
    print(s3_key)
    # Create a CloudWatch Logs client
    cloudwatch_client = boto3.client('logs')
    
    # Define the CloudWatch Log Group and Log Stream
    log_group_name = os.environ['LOG_GROUP']
    log_stream_name = os.environ['LOG_STREAM']
    print(log_group_name)
    print(log_stream_name)
    # Read the S3 object content
    s3_client = boto3.client('s3')
    response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
    log_content = response['Body'].read().decode('utf-8')
    print(log_content)
    try:
        '''
        # Create or update the CloudWatch Log Group
        cloudwatch_client.create_log_group(logGroupName=log_group_name)
        
        # Create or update the CloudWatch Log Stream
        cloudwatch_client.create_log_stream(logGroupName=log_group_name, logStreamName=log_stream_name)
        '''
        timestamp = int(datetime.strptime(event['time'], "%Y-%m-%dT%H:%M:%SZ").timestamp()) * 1000
        print(timestamp)
        # Put the logs into the CloudWatch Log Stream
        response = cloudwatch_client.put_log_events(
            logGroupName=log_group_name,
            logStreamName=log_stream_name,
            logEvents=[
                {
                    'timestamp': timestamp,
                    'message': log_content
                }
            ]
        )
        print(response)
        print("END*******************")
    except Exception as e:
        errorMessage = str(e)
        print(errorMessage)
