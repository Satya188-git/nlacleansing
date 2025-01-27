import logging
import boto3
import os
import re

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
    access_denied_user = False
    access_denied_service_role = False
    for line in lines:
        logger.info(f"Iterating Lines: {line}")
        if ("REST.GET.OBJECT" in line) and ("AccessDenied" in line):
            if("AWSReservedSSO" in line):
                email_pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
                emails = re.findall(email_pattern, str(line))
                access_denied_user = True
                break
            if("AWSServiceRoleFor" in line):
                access_denied_service_role = True
                break
    if access_denied_user:
        User_email_string = ', '.join(emails)
        message = "Unauthorized Access Detected For User: " + User_email_string + " on " + bucket + "/" + key
        subject = "NLA : S3 Unauthorized Access Alert For User"
        logger.info(message)
        send_sns_notification(message, subject)
    if access_denied_service_role:
        message = "Access Denied detected for Service Role : " + bucket + "/" + key
        subject = "NLA : S3 Access Denied Alert For Service Role"
        logger.info(message)
        send_sns_notification(message, subject)

# defination of sns and publish notification
def send_sns_notification(message, subject):
    sns_client = boto3.client("sns")
    sns_topic = sns_topic_arn
    logger.info(f"sns topic: {sns_topic}")
    try:
        response = sns_client.publish(
            TopicArn=sns_topic, Message=message, Subject=subject
        )
    except Exception as e:
        logger.info("error in publishing msg")
        logger.error(str(e))
