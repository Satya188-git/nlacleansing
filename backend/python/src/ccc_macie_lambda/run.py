import json
import boto3
from urllib.parse import unquote_plus

import functions_definitions as my


import logging
import sys
import boto3
from botocore.exceptions import ClientError


target_buckets_list = ['customercallcenterpiicleaned']
# target_buckets_list = ['customercallcenterpiitranscription']


# job_name = 'Scanning the Transcription bucket (unclean)'
job_name = 'Scanning the Cleaned bucket 5'

# job_desc = 'This is a test to scan unclean data'
job_desc = "This is a test to scan clean data"

job_tags = {
    '4BBB57DFE4C0A8939C612246DFE85EAE': '4BBB57DFE4C0A8939C612246DFE85EAE',
    'Customer Sentiment': 'PII Cleansing'
}
"""
custom_data_identifiers_list = [
    {
        'name': 'CCC-Digits',
        'description': 'This will capture numbers longer than 2 digits (includes account numbers)',
        'regex': "\d{3,}"
    },{
        'name': 'CCC-Amount',
        'description': 'This will capture dollar amounts',
        'regex': "\$?\d*.\d*.\d+"
    },{
        'name': 'CCC-PhoneNumbers',
        'description': 'This will capture phone numbers',
        'regex': "\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{1,4})(?: *x(\d+))?\s*"
    },{
        'name': 'CCC-Spellings',
        'description': 'This will capture when client have spelled some names',
        'regex': "([A-Z]{1}\.?\s){3,}"
    },{
        'name': 'CCC-Dates',
        'description': 'This will capture dates mentioned by Month names',
        'regex': "(?:Jan(?:uary)?|jan(?:uary)?|Feb(?:ruary)?|feb(?:ruary)?|Mar(?:ch)?|mar(?:ch)?|Apr(?:il)?|apr(?:il)?|May|may|Jun(?:e)?|jun(?:e)?|Jul(?:y)?|jul(?:y)?|Aug(?:ust)?|aug(?:ust)?|Sep(?:tember)?|sep(?:tember)?|Oct(?:ober)?|cct(?:ober)?|(Nov|nov|Dec|dec)(?:ember)?)\s?\D?(\d{1,4}(st|nd|rd|th)?)?(([,.\-\/])\D?)?"
    },{
        'name': 'CCC-kilowatt',
        'description': 'This will capture number of kilowatts',
        'regex': "\d+,?\d+\s(kilowatt|kW|kw|Kilowatt)"
    }
]
"""


custom_data_identifiers_list = [
    {
        'name': 'CCC-Dates',
        'description': 'This will capture dates mentioned by Month names',
        'regex': "(?:Jan(?:uary)?|jan(?:uary)?|Feb(?:ruary)?|feb(?:ruary)?|Mar(?:ch)?|mar(?:ch)?|Apr(?:il)?|apr(?:il)?|May|may|Jun(?:e)?|jun(?:e)?|Jul(?:y)?|jul(?:y)?|Aug(?:ust)?|aug(?:ust)?|Sep(?:tember)?|sep(?:tember)?|Oct(?:ober)?|cct(?:ober)?|(Nov|nov|Dec|dec)(?:ember)?)\s?\D?(\d{1,4}(st|nd|rd|th)?)?(([,.\-\/])\D?)?"
    }
]


def lambda_handler(event, context):

    # print(event)

    # record = event['Records'][0]

    # s3bucket = record['s3']['bucket']['name']
    # s3object = record['s3']['object']['key']
    # s3object = unquote_plus(s3object)
    # print(s3bucket)
    # print(s3object)

    ##########################################################
    # we need to change the job creation to only look at blob content and not the rest

    # removing the subfolder name and keeping only the filename
    # s3filename = s3object.split('/')[-1]
    # s3filename = "".join(s3filename.split('.')[:-1])    #removing the file extension
    # print("The actual file name is:", s3filename)

    # Creating the clients
    # s3client = boto3.client('s3')
    s3client = boto3.resource('s3')

    ssm_client = boto3.client('ssm')
    sts_client = boto3.client('sts')
    macie_client = boto3.client('macie2')

    my.create_custom_data_identifiers(
        macie_client, custom_data_identifiers_list, job_tags)

    """
    logging.basicConfig(format='[%(asctime)s] %(levelname)s – %(message)s', level=logging.INFO)
    
    

    # Collecting the required information
    account_id = sts_client.get_caller_identity()['Account']
    custom_data_identifiers = my.list_custom_data_identifiers(macie_client)


    # Creating the Macie Job
    #try:
    
    response = macie_client.create_classification_job(
        customDataIdentifierIds=custom_data_identifiers,
        description= job_desc,
        jobType='ONE_TIME',
        #initialRun=True,
        name= job_name,
        managedDataIdentifierSelector='ALL',
        s3JobDefinition={
            'bucketDefinitions': [
                {
                    'accountId': account_id,
                    'buckets': target_buckets_list
                }
            ]#,
            # 'scoping': {
            #     'includes': {
            #         'and': [
            #             {
            #                 'simpleScopeTerm': {
            #                     'comparator': 'EQ',
            #                     'key': 'OBJECT_EXTENSION',
            #                         'csv',
            #                     ]
            #                 }
            #             },
            #         ]
            #     }
            # }
        },
        samplingPercentage=100,
        tags = job_tags
    )
    logging.debug(f'Response: {response}')
    
    #except ClientError as e:
    #    logging.error(e)
    #    sys.exit(e)
    """
