import os
import boto3
import uuid
import status_list
from datetime import datetime

s3 = boto3.resource("s3")


def lambda_handler(event, context):
    print("Event Name ", event)

    # Get bucket and file name
    bucket = event['detail']['bucket']['name']
    key = event['detail']['object']['key']


    folder = os.path.dirname(key)
    file = os.path.basename(key)
    file_ext = os.path.splitext(file)[1]

    if file_ext not in ('.wav', '.txt', '.json'):
        quit()

    if folder:
        path = bucket + '/' + folder + '/'
    else:
        path = bucket

    # Create a DynamoDB client
    dynamodb = boto3.resource("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    table = dynamodb.Table(table_name)

    # Create random UUID
    id = str(uuid.uuid4())

    split_file = file.split('_')
    call_type = split_file[1]
    call_id = split_file[2]

    status = ""

    if path == "customercallcenterpiiunrefined":
        status = status_list.AUDIO_FILE_RECEIVED
    elif path == "customercallcenterpiitranscription/standard/":
        status = status_list.AUDIO_TRANSCRIPT_WITHSPEAKERLABEL_GENERATED
    elif path == "customercallcenterpiitranscription/standard_full_transcripts/":
        status = status_list.TRANSCRIPT_SIMPLETEXT_WITHPII_GENERATED
    elif path == "customercallcenterpiicleaned/standard_full_transcripts/":
        status = status_list.TRANSCRIPT_SIMPLETEXT_NOPII_GENERATED
    elif path == "customercallcenterpiicleaned/final_outputs/":
        status = status_list.FINAL_INDENTED_OUTPUT_GENERATED
    elif path == "customercallcenterpiicleaned/final_outputs2/":
        status = status_list.FINAL_NONINDENTED_OUTPUT_GENERATED
    elif path == "customercallcenterpiicleanedverified/standard_full_transcripts/":
        status = status_list.STANDARD_FULL_TRANSCRIPT_CLEANED_VERIFIED
    elif path == "customercallcenterpiicleanedverified/final_outputs/":
        status = status_list.FINAL_VERIFIED_INDENTED_OUTPUT_GENERATED
    elif path == "customercallcenterpiicleanedverified/final_outputs2/":
        status = status_list.FINAL_VERIFIED_NONINDENTED_OUTPUT_GENERATED
    elif path == "customercallcenterpiidirty/":
        status = status_list.STANDARD_FULL_TRANSCRIPT_DIRTY_VERIFIED


    now = datetime.now()
    # dd/mm/YY H:M:S
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

    table.put_item(
        Item={"UUID": id, "CallType": call_type, "CallID": call_id, "Path": path, "FileName": file, "Status": status,
              "DateTimeStamp": dt_string})


if __name__ == '__main__':
    os.environ["TABLE_NAME"] = "visit-count-table"
    event = {"user": "jack"}
    print(lambda_handler(event, None))
