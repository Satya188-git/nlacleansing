import logging
import boto3
import os

sns_topic_arn = os.environ["SNS_TOPIC_ARN"]
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# lambda to send email notification if someone try to download files from important PII buckets.
def lambda_handler(event, context):
    # reading the event
    logger.info(event)
    s3_bucket = event["detail"]["bucket"]["name"]
    s3_key = event["detail"]["object"]["key"]
    logger.info(s3_bucket + "/" + s3_key)
    try:
        # read the s3 object content
        s3_client = boto3.client("s3")
        response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
        content = response["Body"].read().decode("utf-8")
        check_access_denied(content, s3_bucket, s3_key)
    except Exception as e:
        logger.error(str(e))


def check_access_denied(content, bucket, key):
    lines = content.splitlines()
    access_denied = False
    for line in lines:
        if ("REST.GET.OBJECT" in line) and ("AccessDenied" in line):
            access_denied = True
            break
    if access_denied:
        message = "Access Denied detected in : " + bucket + "/" + key
        logger.info(message)
        send_sns_notification(message)

# defination of sns and publish notification
def send_sns_notification(message):
    sns_client = boto3.client("sns")
    sns_topic = sns_topic_arn
    logger.info(f"sns topic: {sns_topic}")
    try:
        response = sns_client.publish(
            TopicArn=sns_topic, Message=message, Subject="NLA : S3 Access Denied Alert."
        )
    except Exception as e:
        logger.info("error in publishing msg")
        logger.error(str(e))
