import boto3
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
import sys

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
job.init(args['JOB_NAME'], args)

# Read data from Glue table
dynamic_frame = glueContext.create_dynamic_frame.from_catalog(database="sdge-dtdes-dev-wus2-gdc-nla-s3-crawler-sdge_dtdes_dev_wus2_nla_athena_db", table_name="sdge_dtdes_dev_wus2_glue_nla_s3_crawler_historical_calls")

# Convert to DataFrame
df = dynamic_frame.toDF()

# Initialize SQS client
sqs = boto3.client('sqs', region_name='us-west-2')
queue_url = 'https://sqs.us-west-2.amazonaws.com/183095018968/sdge-dtdes-dev-wus2-sqs-historical-dataloader-q'

# Send each row as a message to SQS
for row in df.collect():
    message_body = row.asDict()
    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=str(message_body)
    )

job.commit()
