import boto3
import json

# Load the JSON file
with open('files_cr_nla_audio_Nov7.json', 'r') as file:
    data = json.load(file)

# Specify your S3 bucket name
bucket_name = 'callrecordings-dev-nla'

# Create an S3 client
s3 = boto3.client('s3')

# Iterate through each entry and delete from S3
for entry in data:
    key = entry['Key']
    s3.delete_object(Bucket=bucket_name, Key=key)
    print(f"Deleted {key} from {bucket_name}")
