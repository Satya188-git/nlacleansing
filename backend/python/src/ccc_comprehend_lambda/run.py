import json
import boto3
import re
import os
from urllib.parse import unquote_plus
import functions_definitions as my


CHANNEL_ID_AGENT = 0
CHANNEL_ID_CUSTOMER = 1
# we are also using these in Lambda-Transcribe


cleaned_bucket_name = os.environ["CLEANED_BUCKET_NAME"]


def lambda_handler(event, context):

    print(event)

    # record = event['detail']
    # print("Record Name", record)

    # s3bucket = record['bucket']['name']
    # s3object = record['object']['key']
    # s3object = unquote_plus(s3object)
    # print("s3bucket is ", s3bucket)
    # print("s3object is ", s3object)
    
    print("Event Name ", event)
    record = event["detail"]
    print("Record Name", record)
    s3bucket = record['bucket']['name']
    s3object = record['object']['key']
    print(s3bucket)
    print(s3object)

    # removing the subfolder name and keeping only the filename
    s3filename = s3object.split('/')[-1]
    # removing the file extension
    s3filename = "".join(s3filename.split('.')[:-1])
    print("The actual file name is:", s3filename)
    
    print(re.findall("(^.*_Summed)_.*$", s3filename))

    system_filename = re.findall("(^.*_Summed)_.*$", s3filename)[0] + ".wav"
    print("The system file name is:", system_filename)

    # Creating the clients
    # s3client = boto3.client('s3')
    s3client = boto3.resource('s3')
    comprehend = boto3.client('comprehend')

    # Extracting the metadata with Athena
    # result = my.capture_file_metdadata(system_filename)
    # print(result)

    # Reading the content of the file
    content_object = s3client.Object(s3bucket, s3object)
    print("content_object is ", content_object)
    file_content = content_object.get()['Body'].read().decode("utf-8")
    json_content = json.loads(file_content)
    print("JSON content:", json_content)

    #################################################
    # Extract the transcript parts, based on Type of API (Standard or Call Analytics)

    if "_standard" in s3filename:

        # Extract Content
        full_transcript = my.read_output_standard(
            json_content, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER)
        # print("Here is the full transcription:", full_transcript)

        # Save the Transcript content to S3
        s3_path = "standard_full_transcripts/" + s3filename + ".txt"
        response = s3client.Bucket(s3bucket).put_object(
            Key=s3_path, Body=full_transcript, ContentType='text/plain')
        # since this results are uncleaned, we will store them in uncleaned bucket

        # Performing cleaning on Full Transcript text
        my.perform_pi_redaction_full_transcript(
            comprehend, s3client, s3filename, cleaned_bucket_name, full_transcript)

        # Performing cleaning on STANDARD json
        # my.perform_pi_redaction_standard(comprehend, s3client, s3filename, cleaned_bucket_name, json_content)

        # constrcting the final output
        my.construct_final_output(comprehend, s3client, cleaned_bucket_name, s3filename,
                                  system_filename, json_content, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER)

    elif "_callanalytics" in s3filename:

        # Extract content
        full_transcript = my.read_output_callanalytics(json_content)

        # Save the Transcript content to S3
        s3_path = "analytics_full_transcripts/" + s3filename + ".txt"
        response = s3client.Bucket(s3bucket).put_object(
            Key=s3_path, Body=full_transcript, ContentType='text/plain')
        # since this results are uncleaned, we will store them in uncleaned bucket

        # Performing cleaning on CALL ANALYTICS json
        my.perform_pi_redaction_callanalytics(
            comprehend, s3client, s3filename, cleaned_bucket_name, json_content)

    return response
