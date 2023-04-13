import boto3
# import os
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

    # response = "".join([c if c.isalnum() or c == '.' else '_' for c in object_name])
    response = "".join([c if c.isalnum() else '_' for c in object_name])

    return response

# ----------------------------------------------------------------#


def fix_file_name(client, bucket, key):

    # there are issues when the file is having space character in the name
    # using this function we will rename the file in S3 and remove the space character

    # Removing the URL encoding when there is an space in the filename
    old_name_decode = unquote_plus(key)
    for char in old_name_decode:
        if not char.isalnum() or char != '.' or char != '_':
            new_name = "".join(
                [c if c.isalnum() or c == '.' else '_' for c in old_name_decode])
            copy_source = {'Bucket': bucket, 'Key': old_name_decode}
            client.copy_object(CopySource=copy_source,
                               Bucket=bucket, Key=new_name)
            client.delete_object(Bucket=bucket, Key=old_name_decode)
            return new_name

    return key

# ----------------------------------------------------------------#


def make_stereo(s3client, bucket, key):

    output = key + "_stereo.wav"
    response = s3client.get_object(Bucket=bucket, Key=key)

    ifile = wave.open(key)
    print(ifile.getparams())
    # (1, 2, 44100, 2013900, 'NONE', 'not compressed')
    (nchannels, sampwidth, framerate, nframes,
     comptype, compname) = ifile.getparams()
    assert comptype == 'NONE'  # Compressed not supported yet
    array_type = {1: 'B', 2: 'h', 4: 'l'}[sampwidth]
    left_channel = array.array(array_type, ifile.readframes(nframes))[
        ::nchannels]
    ifile.close()

    stereo = 2 * left_channel
    stereo[0::2] = stereo[1::2] = left_channel

    ofile = wave.open("/tmp/{}.wav".format(output), 'w')
    ofile.setparams((2, sampwidth, framerate, nframes, comptype, compname))
    ofile.writeframes(stereo.tostring())
    ofile.close()

    response = s3_client.upload_file(Filename="/tmp/{}".format(output),
                                     Bucket=bucket,
                                     Key='{}'.format(output))
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
            job_status = transcribe.get_call_analytics_job(CallAnalyticsJobName=job_name)[
                "CallAnalyticsJob"]["CallAnalyticsJobStatus"]
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
            transcribe.delete_call_analytics_job(CallAnalyticsJobName=job_name)
        else:
            transcribe.delete_transcription_job(TranscriptionJobName=job_name)
    except Exception as e:
        # If the job has already been deleted then we don't need to take any action
        pass

# -----------------------------------------------------------------#
# we need to do analysis on the logic of this function and try to leverage it


def evaluate_transcribe_mode(bucket, key):
    """
    The user can configure which API and which speaker separation method to use, but this will validate that those
    options are valid for the current file and will overrule/downgrade the options.  The rules are:
    (1) If you ask for speaker-separation and you're not doing ANALYTICS then you get it
    (2) If you ask for channel-separation or ANALYTICS but the file is mono then you get STANDARD speaker-separation
    (3) If you ask for ANALYTICS on a 2-channel file then it ignores your speaker/channel-separation setting
    (4) If the audio has neither 1 nor 2 channels then you get STANDARD API with speaker-separation
    @param bucket: Bucket holding the audio file to be tested
    @param key: Key for the audio file in the bucket
    @return: Transcribe API mode and flag for channel separation
    """
    # Determine the correct API and speaker separation that we'll be using
    api_mode = cf.appConfig[cf.CONF_TRANSCRIBE_API]
    # channel_count = count_audio_channels(bucket, key)
    channel_mode = cf.appConfig[cf.CONF_SPEAKER_MODE]
    if channel_count == 1:
        # Mono files are always sent through Standard Transcribe with speaker separation, as using
        # either Call Analytics or channel separation will results in sub-standard transcripts
        api_mode = cf.API_STANDARD
        channel_ident = False
    elif channel_count == 2:
        # Call Analytics only works on stereo files - if you configure both
        # ANALYTICS and SPEAKER_SEPARATION then the ANALYTICS mode wins
        if api_mode == cf.API_ANALYTICS:
            channel_ident = True
        else:
            # We're in standard mode with a stereo file - use speaker separation
            # if that was configured, otherwise we'll use channel separation
            channel_ident = (channel_mode != cf.SPEAKER_MODE_SPEAKER)
    else:
        # We could have a file with 0 or > 2 channels - default to 1 (but the file will likely break)
        api_mode = cf.API_STANDARD
        channel_ident = False

    return api_mode, channel_ident
