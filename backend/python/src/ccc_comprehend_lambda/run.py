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
        # Handle 'NoneType' object is not subscriptable
        print(f"TypeError: {e}")
		
		# Create a Lambda client
        lambda_client = boto3.client('lambda')
        lambda_arn = os.environ['audit_lambda_arn']
		
        if isinstance(e, TypeError):
			# Modify the event data before passing it to LambdaFunctionB
            modified_event_transcript = {
                'source': 'aws.lambda',
                'detail': {
                    'bucket': {
                        'name': event['detail']['bucket']['name']
                    },
                    'object': {
                        'key': event['detail']['object']['key']
                    },
                    'status': 'Comprehend-lambda-failed:Transcript is missing'
                }
            }
            print(modified_event_transcript)
            # Invoke LambdaFunctionB with the modified payload
            response = lambda_client.invoke(
                FunctionName=lambda_arn,
                InvocationType='RequestResponse',  # Use 'Event' for asynchronous invocation
                Payload=json.dumps(modified_event_transcript)  # Convert the payload to JSON
            )

        elif isinstance(e, IndexError):
            # Modify the event data before passing it to LambdaFunction
            modified_event_meta = {
                'source': 'aws.lambda',
                'detail': {
                    'bucket': {
                        'name': event['detail']['bucket']['name']
                    },
                    'object': {
                        'key': event['detail']['object']['key']
                    },
                    'status': 'Comprehend-lambda-failed:Metadata is missing'
                }
            }
            print(modified_event_meta)
            # Invoke LambdaFunctionB with the modified payload
            response = lambda_client.invoke(
                FunctionName=lambda_arn,
                InvocationType='RequestResponse',  # Use 'Event' for asynchronous invocation
                Payload=json.dumps(modified_event_meta)  # Convert the payload to JSON
            )

        else:
            print(f"Other Exception: {e}")
            modified_event_comprehend = {
                'source': 'aws.lambda',
                'detail': {
                    'bucket': {
                        'name': event['detail']['bucket']['name']
                    },
                    'object': {
                        'key': event['detail']['object']['key']
                    },
                    'status': 'ERROR:comprehend-lambda-failed'
                }
            }
            print(modified_event_comprehend)
            # Invoke LambdaFunctionB with the modified payload
            response = lambda_client.invoke(
                FunctionName=lambda_arn,
                InvocationType='RequestResponse',  # Use 'Event' for asynchronous invocation
                Payload=json.dumps(modified_event_comprehend)  # Convert the payload to JSON
            )

