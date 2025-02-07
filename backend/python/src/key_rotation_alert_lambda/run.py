import boto3
from time import gmtime, strftime
from datetime import datetime
import logging
from botocore.exceptions import ClientError
import os

rotation_alert_sns_arn = os.getenv('ROTATION_ALERT_SNS_ARN')
# Initialize logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def rotation_alert_triggers():
    try:
        iam_client = boto3.client('iam')
        response = iam_client.list_users()
        user_list = []
        todays_date = strftime("%Y-%m-%d %H:%M:%S", gmtime())
        todays_date = str(todays_date)
        todays_date = todays_date[0:10]
        todays_date = datetime.strptime(todays_date, "%Y-%m-%d")
        email_body = "Users having access keys older than 75 days \n"                        
        for iam_users in response["Users"]:
            iam_users_list = iam_users["UserName"]
            access_keys = iam_client.list_access_keys(UserName=iam_users_list)
            for key_data in access_keys["AccessKeyMetadata"]:
                if key_data['Status'] == 'Active':
                    keyID = key_data["AccessKeyId"]
                    status = key_data["Status"]
                    CreateDate = key_data.get("CreateDate","none")
                    CreateDate = str(CreateDate)
                    CreateDate = CreateDate[0:10]
                    CreateDate = datetime.strptime(CreateDate, "%Y-%m-%d")

                    total_days =  abs((CreateDate - todays_date).days)
                 
                    if total_days > 75:
                        user_list.append({
                        "UserName:":iam_users_list,
                        "Status:": status,
                        "Days Old": total_days
                        })  

                
        if user_list:
            email_body = email_body +  "user_list = {} \n".format(user_list)
            logger.info(email_body)
            sns_client = boto3.client('sns')
            sns_client.publish(
                TopicArn = rotation_alert_sns_arn,
                Subject = "List of Users with access key older than 75 day",
                Message = email_body
            )
            logger.info("Message has been sent")
        else:
            logger.info("There are no keys older than 75 days")
            # print(user_list)          
        
    except Exception as error:
        logger.error("Execution failed. Error: %s", error)    

def lambda_handler(event, context):
    logger.info(
        "Triggered {0} lambda function with event: {1}".format(
            '"key-rotation-alert"', event
        )
    )
    rotation_alert_triggers()

    return event    
