import json
import boto3
import re
import os
from urllib.parse import unquote_plus
import functions_definitions as my


CHANNEL_ID_AGENT = 0
CHANNEL_ID_CUSTOMER = 1

cleaned_bucket_name = os.environ["CLEANED_BUCKET_NAME"]
STANDARD_FULL_TRANSCRIPT_SUB_FOLDER = os.environ["STANDARD_FULL_TRANSCRIPT_SUB_FOLDER"]
STANDARD_FULL_TRANSCRIPT_FILE_FORMAT = os.environ["STANDARD_FULL_TRANSCRIPT_FILE_FORMAT"]
STANDARD_FULL_TRANSCRIPT_CONTENT_TYPE = os.environ["STANDARD_FULL_TRANSCRIPT_CONTENT_TYPE"]


def modify_and_invoke_lambda(event, error_type, status_message):
    modified_event = {
        'source': 'aws.lambda',
        'detail': {
            'bucket': {
                'name': event['detail']['bucket']['name']
            },
            'object': {
                'key': event['detail']['object']['key']
            },
            'status': status_message
        }
    }

    print(modified_event)
    
    lambda_client = boto3.client('lambda')
    lambda_arn = os.environ['audit_lambda_arn']
    
    lambda_response = lambda_client.invoke(
        FunctionName=lambda_arn,
        InvocationType='RequestResponse',
        Payload=json.dumps(modified_event)
    )



def lambda_handler(event, context):

    try :
        
        record = event["detail"]
        s3bucket = record['bucket']['name']
        s3object = record['object']['key']
    
        # removing the subfolder name and keeping only the filename
        s3filename = s3object.split('/')[-1]
        # removing the file extension
        s3filename = "".join(s3filename.split('.')[:-1])
        system_filename = re.findall("(^.*_Summed)_.*$", s3filename)[0] + ".wav"
        s3client = boto3.resource('s3')
        
        comprehend = boto3.client('comprehend')
    
        # Reading the content of the file
        content_object = s3client.Object(s3bucket, s3object)
        file_content = content_object.get()['Body'].read().decode("utf-8")
        json_content = json.loads(file_content)
    
        #################################################
        # Extract the transcript parts, based on Type of API (Standard or Call Analytics)
    
        if "_standard" in s3filename:
    
            # Extract Content
            full_transcript = my.read_output_standard(
                json_content, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER)
    
            # Save the Transcript content to S3
            s3_path = STANDARD_FULL_TRANSCRIPT_SUB_FOLDER + \
                s3filename + STANDARD_FULL_TRANSCRIPT_FILE_FORMAT
            response = s3client.Bucket(s3bucket).put_object(
                Key=s3_path, Body=full_transcript, ContentType=STANDARD_FULL_TRANSCRIPT_CONTENT_TYPE)
    
            # since this results are uncleaned, we will store them in uncleaned bucket
    
            # Performing cleaning on Full Transcript text
            my.perform_pi_redaction_full_transcript(
                comprehend, s3client, s3filename, cleaned_bucket_name, full_transcript)
    
            # constrcting the final output
            my.construct_final_output(comprehend, s3client, cleaned_bucket_name, s3filename,
                                      system_filename, json_content, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER)
    
        elif "_callanalytics" in s3filename:
            print("Do not support Analytics")
            
    except Exception as e:
            print(f"Exception: {e}")
    
            if isinstance(e, (TypeError, IndexError)):
                error_type = 'Transcript is missing' if isinstance(e, TypeError) else 'Metadata is missing'
                status_message = f'Comprehend-lambda-failed:{error_type}'
                modify_and_invoke_lambda(event, e, status_message)
    
            else:
                print(f"Other Exception: {e}")
                status_message = 'ERROR:comprehend-lambda-failed'
                modify_and_invoke_lambda(event, e, status_message)

