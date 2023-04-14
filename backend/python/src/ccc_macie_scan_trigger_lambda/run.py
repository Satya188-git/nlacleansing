import json
import boto3
import os


CLIENT_TOKEN = os.environ["CLIENT_TOKEN"]
JOB_TYPE = os.environ["JOB_TYPE"]
MANAGE_DATA_IDENTIFIER_SELECTOR = os.environ["MANAGE_DATA_IDENTIFIER_SELECTOR"]
ACCOUNT_ID = os.environ["ACCOUNT_ID"]
BUCKET_NAME = os.environ["BUCKET_NAME"]
SAMPLING_PERCENTAGE = os.environ["SAMPLING_PERCENTAGE"]


def lambda_handler(event, context):

    macie_client = boto3.client('macie2')
    s3_client = boto3.client('s3')
    record = event["time"]
    description_line = record
    response = macie_client.create_classification_job(
        clientToken=CLIENT_TOKEN,
        initialRun=False,
        jobType=JOB_TYPE,
        managedDataIdentifierSelector=MANAGE_DATA_IDENTIFIER_SELECTOR,
        name=description_line,
        s3JobDefinition={
            "bucketDefinitions": [
                {
                    "accountId": ACCOUNT_ID,
                    "buckets": [
                        BUCKET_NAME
                    ]
                }
            ],
            "scoping": {
                "excludes": {
                    "and": [
                        {
                            "simpleScopeTerm": {
                                "comparator": "STARTS_WITH",
                                "key": "OBJECT_KEY",
                                "values": [
                                    "final_outputs/"
                                ]
                            }
                        }
                    ]
                },
                "includes": {
                    "and": [
                        {
                            "simpleScopeTerm": {
                                "comparator": "STARTS_WITH",
                                "key": "OBJECT_KEY",
                                "values": [
                                    "standard_full_transcripts/"
                                ]
                            }
                        }
                    ]
                }
            }
        },
        samplingPercentage=100,
    )
