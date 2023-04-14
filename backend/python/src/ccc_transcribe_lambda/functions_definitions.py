import boto3
from urllib.parse import unquote_plus
import wave
import array

# ----------------------------------------------------------------#


def generate_job_name(key):
    """
    Transcribe job names cannot contain spaces.  This takes in an S3
    object key, extracts the filename part, replaces spaces with "-"
    characters and returns that as the job-name to use
    """

    # Removing the URL encoding when there is an space in the filename
    object_name = unquote_plus(key)

    response = "".join([c if c.isalnum() else '_' for c in object_name])

    return response

# ----------------------------------------------------------------#


def check_existing_job_status(transcribe, job_name, api_mode):
    """
    Checks the status of the named transcription job, either in the Standard Transcribe APIs or
    the Call Analytics APIs.  This is required before launching a new job, as our job names are
    based upon the name of the input audio file, but Transcribe jobs need to be uniquely named
    @param job_name: Name of the transcription job to check for
    @param transcribe: Boto3 client for the Transcribe service
    @param api_mode: Transcribe API mode being used (can be "analytics" or "standard")
    @return: Status of the transcription job, empty string means the job didn't exist
    """

    try:
        # Extract the standard Transcribe job status from the correct API
        if api_mode == "analytics":
            print("Unsupported job type")
        else:
            job_status = transcribe.get_transcription_job(TranscriptionJobName=job_name)[
                "TranscriptionJob"]["TranscriptionJobStatus"]
    except Exception as e:
        # Job didn't already exist - carry on
        job_status = ""

    return job_status

# ----------------------------------------------------------------#


def delete_existing_job(transcribe, job_name, api_mode):
    """
    Deletes the specified transcription job from either the Standard or Call Analytics APIs
    @param job_name: Name of the transcription job to delete
    @param transcribe: Boto3 client for the Transcribe service
    @param api_mode: Transcribe API mode being used
    """
    try:
        if api_mode == "analytics":
            print("Unsupported job type")
        else:
            transcribe.delete_transcription_job(TranscriptionJobName=job_name)
    except Exception as e:
        # If the job has already been deleted then we don't need to take any action
        pass
