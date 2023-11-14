import json
import boto3
import os
from datetime import datetime, timedelta
from datetime import timezone

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

    # Check if there's a currently running job
    response = macie_client.list_classification_jobs(
        filterCriteria={
            'excludes': [],
            'includes': [
                {
                    'comparator': 'EQ',
                    'key': 'jobStatus',
                    'values': ['RUNNING']
                },
            ]
        }
    )
    
    # Check if any jobs are in the "RUNNING" state
    running_jobs = [job for job in response.get("items", []) if job.get("jobStatus") == 'RUNNING']

    if not running_jobs:
        # No running jobs, so create a new job

        # Check if the last completed Macie job was more than 5 minutes ago
        last_completed_job_response = macie_client.list_classification_jobs(
            filterCriteria={
                'excludes': [],
                'includes': [
                    {
                        'comparator': 'EQ',
                        'key': 'jobStatus',
                        'values': ['COMPLETE']
                    },
                ]
            },
            sortCriteria=
                {
                    'attributeName': 'createdAt', 
                    'orderBy': 'DESC'
                                       
                },
            
        )

        if last_completed_job_response.get("items"):
            
            last_completed_job_timestamp = last_completed_job_response["items"][0]["createdAt"]

            if isinstance(last_completed_job_timestamp, str):
                last_completed_job_time = datetime.strptime(last_completed_job_timestamp, "%Y-%m-%dT%H:%M:%SZ")
            else:
                last_completed_job_time = last_completed_job_timestamp

           # last_completed_job_time = datetime.strptime(last_completed_job_timestamp, "%Y-%m-%dT%H:%M:%SZ")
            current_time = datetime.utcnow().replace(tzinfo=timezone.utc)

            if (current_time - last_completed_job_time) < timedelta(minutes=5):
                # If the last completed job was less than 5 minutes ago, print a message and skip job creation
                print("The last completed Macie job was less than 5 minutes ago. Skipping job creation.")
            else:
                # Check if the Macie bucket is non-empty
                final_output_folder_key = "standard_full_transcripts"
                bucket_response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=final_output_folder_key)
                print("bucket list:", bucket_response )
                is_bucket_empty = 'Contents' not in bucket_response

                if is_bucket_empty:
                    # If the Macie bucket is empty, print a message and skip job creation
                    print("The Macie bucket is empty. Skipping job creation.")
                else:
                    # Create a new job
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
        else:
            # If no completed jobs found, proceed with job creation
            print("No completed Macie jobs found. Proceeding with job creation.")
            
            # ... (the rest of the job creation logic)
    else:
        # If there are running jobs, log this and skip job creation
        print("There is already a running Macie job. Skipping job creation.")
