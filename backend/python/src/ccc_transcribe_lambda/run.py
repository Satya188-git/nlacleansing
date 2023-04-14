
import json
import boto3
import functions_definitions as my
import os

CONF_VOCAB_FILTER_MODE = os.environ["CONF_VOCAB_FILTER_MODE"]
CONF_CUSTOM_VOCAB_NAME = os.environ["CONF_CUSTOM_VOCAB_NAME"]
CONF_FILTER_NAME = os.environ["CONF_FILTER_NAME"]
CONF_MAX_SPEAKERS = os.environ["CONF_MAX_SPEAKERS"]
CONF_REDACTION_LANGS = os.environ["CONF_REDACTION_LANGS"]
CONF_S3BUCKET_OUTPUT = os.environ["CONF_S3BUCKET_OUTPUT"]
CONF_SPEAKER_MODE = os.environ["CONF_SPEAKER_MODE"]
CONF_TRANSCRIBE_API = os.environ["CONF_TRANSCRIBE_API"]
CONF_TRANSCRIBE_LANG = os.environ["CONF_TRANSCRIBE_LANG"]
CONF_VOCABNAME = os.environ["CONF_VOCABNAME"]
CONF_REDACTION_TRANSCRIPT = os.environ["CONF_REDACTION_TRANSCRIPT"]
CONF_DESTINATION_BUCKET_NAME = os.environ["CONF_DESTINATION_BUCKET_NAME"]
KEY = os.environ["KEY"]
VALUE = os.environ["VALUE"]

CONF_MINNEGATIVE = float(0.5)
CONF_MINPOSITIVE = float(0.5)
CONF_ENTITYCONF = float(0.5)

CONF_API_MODE = "standard"
CONF_ROLE_ARN = os.environ["CONF_ROLE_ARN"]

job_tags = [{
    'Key': KEY,
    'Value': VALUE
}]


def lambda_handler(event, context):
    record = event["detail"]
    s3bucket = record['bucket']['name']
    s3object = record['object']['key']

    # Creating the clients
    s3client = boto3.client('s3')
    transcribe = boto3.client('transcribe')

    # Generate job-name
    job_name = my.generate_job_name(s3object)

    job_name_standard = job_name + '_standard'

    # constructing the URI
    uri = 's3://' + s3bucket + '/' + s3object

    ##########################################################################################

    current_job_status_standard = my.check_existing_job_status(
        transcribe, job_name_standard, "standard")

    # If there's a job already running then the input file may have been copied - quit
    if (current_job_status_standard == "IN_PROGRESS") or (current_job_status_standard == "QUEUED"):
        print("A Transcription job named \'{}\' is already in progress - cannot continue.".format(job_name))
        return ""
    elif current_job_status_standard != "":
        my.delete_existing_job(transcribe, job_name_standard,  "standard")

    ###########################################################################################
    # Setup the structures common to both Standard and Call Analytics

    media_settings = {'MediaFileUri': uri}

    # Creating the Channel defition
    channel_definition = [{
        'ChannelId': 0,
        'ParticipantRole': 'AGENT'
    }, {
        'ChannelId': 1,
        'ParticipantRole': 'CUSTOMER'
    }
    ]

    """        
    channel_definition = [{
                            'ChannelId': 1,
                            'ParticipantRole': 'AGENT'
                    }, {
                            'ChannelId': 0,
                            'ParticipantRole': 'CUSTOMER'
                    }
            ]
    """

    ###############################################################################
    # running the job for Standard API

    # defining the settings of the job
    kwargs = {
        'TranscriptionJobName': job_name_standard,
        'IdentifyLanguage': False,
        'LanguageIdSettings': None,
        'LanguageCode': CONF_TRANSCRIBE_LANG,
        'LanguageOptions': None,
        'Media': media_settings,
        'OutputBucketName': CONF_DESTINATION_BUCKET_NAME,
        'OutputKey': 'standard/',
        'Settings': {
            'VocabularyName': CONF_CUSTOM_VOCAB_NAME,
            'VocabularyFilterMethod': CONF_VOCAB_FILTER_MODE,
            "MaxSpeakerLabels": 2,
            "ShowSpeakerLabels": True,
        },
        'JobExecutionSettings': {
            'AllowDeferredExecution': True,
            'DataAccessRoleArn': CONF_ROLE_ARN
        },
        'Tags': job_tags
    }

    # Start the Transcribe job, removing any params that are "None"
    response = transcribe.start_transcription_job(
        **{k: v for k, v in kwargs.items() if v is not None}
    )
    return job_name
