import json
import boto3



# scan_bucket_name = 'customercallcenterpiicleaned'

def lambda_handler(event, context):
    
    print(event)
    macie_client = boto3.client('macie2')
    s3_client = boto3.client('s3')
    response = macie_client.create_classification_job(
        clientToken = 'c94a06ef-120a-482d-8b26-bdfd6693e016',
        # createdAt = "2023-03-08T13:32:31.930Z",
        customDataIdentifierIds = [
          "a79e3ce8-b2b2-44bd-92d6-84ee5c0c4445",
          "9846a2e1-93c9-4e43-af1b-ddbfb6cd0992"
        ],
        description = "Test run job to automate macie",
        initialRun = False,
        # jobArn = "arn:aws:macie2:us-west-2:544868842803:classification-job/be9eee838e42b86c72696291f073f5c8",
        # jobId = "be9eee838e42b86c72696291f073f5c8",
        # "jobStatus": "COMPLETE",
        jobType = "ONE_TIME",
        managedDataIdentifierSelector = "ALL",
        name = "The scan to test on new data from NLA_1245667",
        s3JobDefinition = {
          "bucketDefinitions": [
            {
              "accountId": "544868842803",
              "buckets": [
                "customercallcenterpiicleaned"
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
                      "final_outputs/",
                      "final_outputs2/"
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
        samplingPercentage = 100,
        tags = {
          "4BBB57DFE4C0A8939C612246DFE85EAE": "4BBB57DFE4C0A8939C612246DFE85EAE",
          "Customer Sentiment": "PII Cleansing"
        },
        # "customDataIdentifiersDetails": {
        #   "customDataIdentifiers": [
        #     {
        #       "arn": "arn:aws:macie2:us-west-2:544868842803:custom-data-identifier/9846a2e1-93c9-4e43-af1b-ddbfb6cd0992",
        #       "createdAt": "2022-08-31T17:53:13.000Z",
        #       "deleted": false,
        #       "description": "This will capture numbers longer than 2 digits (includes account numbers)",
        #       "id": "9846a2e1-93c9-4e43-af1b-ddbfb6cd0992",
        #       "name": "CCC-Digits"
        #     },
        #     {
        #       "arn": "arn:aws:macie2:us-west-2:544868842803:custom-data-identifier/a79e3ce8-b2b2-44bd-92d6-84ee5c0c4445",
        #       "createdAt": "2022-08-31T04:19:14.000Z",
        #       "deleted": false,
        #       "description": "This will capture when client have spelled some names",
        #       "id": "a79e3ce8-b2b2-44bd-92d6-84ee5c0c4445",
        #       "name": "CCC-Spellings"
        #     }
        #   ],
        #   "notFoundIdentifierIds": []
        # }
    )
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
