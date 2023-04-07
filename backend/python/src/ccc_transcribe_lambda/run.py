
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

# CONF_API_MODE = "analytics"
CONF_API_MODE = "standard"
CONF_ROLE_ARN = os.environ["CONF_ROLE_ARN"]

job_tags = [{
    'Key': KEY,
    'Value': VALUE
}]


def lambda_handler(event, context):

    # print("Event Name " , event)

    # record = event['Records'][0]
    # print("Record Name", record)

    # s3bucket = record['s3']['bucket']['name']
    # s3object = record['s3']['object']['key']
    # print(s3bucket)
    # print(s3object)
    print("Event Name ", event)
    record = event["detail"]
    print("Record Name", record)
    s3bucket = record['bucket']['name']
    s3object = record['object']['key']
    print(s3bucket)
    print(s3object)

    # Creating the clients
    s3client = boto3.client('s3')
    transcribe = boto3.client('transcribe')

    # Generate job-name
    job_name = my.generate_job_name(s3object)
    # if CONF_API_MODE == "analytics":
    #    job_name = job_name + '_callanalytics'
    # elif CONF_API_MODE == "standard":
    #    job_name = job_name + '_standard'

    # job_name_analytics = job_name + '_callanalytics'
    job_name_standard = job_name + '_standard'

    print("job name: ", job_name_standard)

    # constructing the URI
    uri = 's3://' + s3bucket + '/' + s3object
    print("uri: ", uri)
    # the sample: s3://customercallcenterunrefined/PII_2_Person_Recording_8KHz_Copy.wav

    ##########################################################################################
    # Make Stereo - convert the Mono file to Stereo

    # print(my.make_stereo(s3client, s3bucket, s3object))

    ##########################################################################################
    # Check if the job is already exist and running

    # current_job_status_analytics = my.check_existing_job_status(
    #     transcribe, job_name_analytics, "analytics")
    current_job_status_standard = my.check_existing_job_status(
        transcribe, job_name_standard, "standard")

    # print("Current job status - analytics: ", current_job_status_analytics)
    print("Current job status - standard: ", current_job_status_standard)

    # If there's a job already running then the input file may have been copied - quit
    if (current_job_status_standard == "IN_PROGRESS") or (current_job_status_standard == "QUEUED"):
        # Return empty job name
        print("A Transcription job named \'{}\' is already in progress - cannot continue.".format(job_name))
        print("11111111111111111111111111111111111111111")
        return ""
    elif current_job_status_standard != "":
        # But if an old one exists we can delete it
        # we want to attempt to delete both type of jobs
        # CONF_API_MODE = "analytics"
        # CONF_API_MODE = "standard"
        # my.delete_existing_job(transcribe, job_name_analytics,  "analytics")
        print("22222222222222222222222222222222222222222")
        my.delete_existing_job(transcribe, job_name_standard,  "standard")

    ###########################################################################################
    # Setup the structures common to both Standard and Call Analytics

    media_settings = {'MediaFileUri': uri}
    # print("media settings: ", media_settings)

    # The vocal filtering methods

    # The content redaction settings
    content_redaction = ""  # if we want to disable the content redaction
    # content_redaction = {'RedactionType': 'PII', 'RedactionOutput': 'redacted_and_unredacted'}
    # content_redaction = {'RedactionType': 'PII', 'RedactionOutput': 'redacted'}

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
    # running the job for Call Analytics API

    """
    # # defining the settings of the job
    # kwargs = {
    #         'CallAnalyticsJobName': job_name_analytics,
    #         'Media': media_settings,
    #         'OutputLocation': CONF_DESTINATION_BUCKET_URI,
    #         'DataAccessRoleArn': CONF_ROLE_ARN,
    #         'Settings': {
    #                 #'VocabularyName': CONF_CUSTOM_VOCAB_NAME,
    #                 #'VocabularyFilterMethod': CONF_VOCAB_FILTER_MODE,
    #                 #'ContentRedaction': content_redaction,
    #                 'LanguageOptions': [CONF_TRANSCRIBE_LANG]
    #         },
    #         #'Tags': job_tags,                          # There is no tagging allowed
    #         'ChannelDefinitions': channel_definition
    #     }    
    
    # print("all the arguments: ", kwargs)


    # # Start the Transcribe job, removing any params that are "None"
    # response = transcribe.start_call_analytics_job(
    #         **{k: v for k, v in kwargs.items() if v is not None}
    #     )
        
        
    # print("Call Analytics Job submission:", response)    
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
            # 'ContentRedaction': {
            #     'RedactionType': 'PII',
            #     'RedactionOutput': 'redacted_and_unredacted',
            #     'PiiEntityTypes': ['ALL']
            # 'ShowSpeakerLabels': False,
            # 'ChannelIdentification': True
            # 'ChannelIdentification': False         #############test this one........
            # }
        },
        # # START Adding MVP Code
        # 'ContentRedaction': {
        #     'RedactionType':'PII',
        #     'RedactionOutput': 'redacted_and_unredacted',
        #     'PiiEntityTypes': [
        #     'NAME','ADDRESS','BANK_ACCOUNT_NUMBER'
        # ]
        # },
        # # END of Adding MVP Code
        'JobExecutionSettings': {
            'AllowDeferredExecution': True,
            'DataAccessRoleArn': CONF_ROLE_ARN
        },
        'Tags': job_tags
        # 'ContentRedaction': content_redaction
    }

    print("all the arguments: ", kwargs)

    # Start the Transcribe job, removing any params that are "None"
    response = transcribe.start_transcription_job(
        **{k: v for k, v in kwargs.items() if v is not None}
    )

    print("Standard Job submission:", response)

    return job_name
