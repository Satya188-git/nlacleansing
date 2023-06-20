import json
import boto3
from datetime import datetime
from dateutil import tz

def lambda_handler(event, context):

    s3_client = boto3.client("s3")  
    s3_callrecordings_bucket = 'sdge-dtdes-prd-wus2-s3-nla-callrecordings'
    s3_unrefined_bucket = 'sdge-dtdes-prd-wus2-s3-nla-unrefined'
    s3_verified_clean_bucket= 'sdge-dtdes-prd-wus2-s3-nla-verified-clean'
    current_datetime = datetime.now()
    formatted_datetime = current_datetime.strftime("%Y-%m-%dT%H:%M:%S")
    s3_bucket_name = "sdge-dtdes-prd-wus2-s3-nla-diff-files"
    
    # Generate callrecordings list
    paginator = s3_client.get_paginator('list_objects_v2')
    page_iterator = paginator.paginate(Bucket=s3_callrecordings_bucket,Prefix='EDIX_AUDIO/')
    all_objects = []
    for page in page_iterator:
        if 'Contents' in page:
            all_objects.extend(page['Contents'])

    #callrecordings_file_content = []
    callrecordings_file_content_withdate = ''
    for obj in all_objects:
        text = obj['Key']
        #callrecordings_file_content.append(text.split('EDIX_AUDIO', 1)[-1].strip('/'))
        recentobject =  text.split('EDIX_AUDIO', 1)[-1].strip('/') +',' + str(obj['LastModified'].astimezone(tz.UTC)) + "\n"
        callrecordings_file_content_withdate = callrecordings_file_content_withdate + (recentobject) 
    #callrecordings_file_content = '\n'.join(callrecordings_file_content)
    #s3_file_name = 'callrecordings_files.csv'
    #s3_client.put_object(Body=callrecordings_file_content, Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)

    s3_file_name = 'callrecordings_files_withdate.csv'
    s3_client.put_object(Body=callrecordings_file_content_withdate, Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)

    callrecordings_file_values = []
    for obj in all_objects:
        text = obj['Key']
        word_to_cut = "_wav_"
        split_text = text.split(word_to_cut)
        if len(text) > 1:
        	substring = split_text[0]
        	substring = substring.split('EDIX_AUDIO', 1)[-1].strip('/')
        	callrecordings_file_values.append(substring)
    #print(callrecordings_file_values)   
        
    # Generate unrefined list
    paginator = s3_client.get_paginator('list_objects_v2')
    page_iterator = paginator.paginate(Bucket=s3_unrefined_bucket)

    all_objects = []
    for page in page_iterator:
        if 'Contents' in page:
            all_objects.extend(page['Contents'])
    
    #unrefined_file_content = []
    unrefined_file_content_withdate = ''
    for obj in all_objects:
        text = obj['Key']
        #unrefined_file_content.append(text)
        recentobject = obj['Key'] +',' + str(obj['LastModified'].astimezone(tz.UTC)) + "\n"
        unrefined_file_content_withdate = unrefined_file_content_withdate + recentobject
    #unrefined_file_content = '\n'.join(unrefined_file_content)
    #s3_file_name = 'unrefined_files.csv'
    #s3_client.put_object(Body=unrefined_file_content, Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)
    
    s3_file_name = 'unrefined_files_withdate.csv'
    s3_client.put_object(Body=unrefined_file_content_withdate, Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)

    unrefined_file_values = []
    for obj in all_objects:
        text = obj['Key']
        word_to_cut = "_wav_"
        split_text = text.split(word_to_cut)
        if len(text) > 1:
            substring = split_text[0]
            # substring = substring.split('final_insights', 1)[-1].strip('/')
            unrefined_file_values.append(substring)
    #print(unrefined_file_values)

    # Generate verified_clean list
    paginator = s3_client.get_paginator('list_objects_v2')
    page_iterator = paginator.paginate(Bucket=s3_verified_clean_bucket,Prefix='final_outputs/')
    all_objects = []
    for page in page_iterator:
        if 'Contents' in page:
            all_objects.extend(page['Contents'])

    #verified_clean_file_content = []
    verified_clean_file_content_withdate = ''
    for obj in all_objects:
        text = obj['Key']
        #verified_clean_file_content.append(text.split('final_outputs', 1)[-1].strip('/'))
        recentobject =  text.split('final_outputs', 1)[-1].strip('/') +',' + str(obj['LastModified'].astimezone(tz.UTC)) + "\n"
        verified_clean_file_content_withdate = verified_clean_file_content_withdate + (recentobject) 
    #verified_clean_file_content = '\n'.join(verified_clean_file_content)
    #s3_file_name = 'verified_clean_files.csv'
    #s3_client.put_object(Body=verified_clean_file_content, Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)

    s3_file_name = 'verified_clean_files_withdate.csv'
    s3_client.put_object(Body=verified_clean_file_content_withdate, Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)

    verified_clean_file_values = []
    for obj in all_objects:
        text = obj['Key']
        word_to_cut = "_wav_"
        split_text = text.split(word_to_cut)
        if len(text) > 1:
        	substring = split_text[0]
        	substring = substring.split('final_outputs', 1)[-1].strip('/') + '.wav'
        	verified_clean_file_values.append(substring)
            
    # Find the differences between callrecordings and unrefined bucket files
    differences = list(set(callrecordings_file_values) - set(unrefined_file_values))
    print(differences)
    print('differences count between callrecordings and unrefined bucket files - ' + str(len(differences)))
    if(len(differences) > 1):
        s3_file_name = 'unrefined_diff_files.csv'
        s3_client.put_object(Body=json.dumps(differences), Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name) 
    else:
        print("No differences in files in callrecordings and unrefined bucket files")

    # Find the differences between callrecordings and verified_clean bucket files
    print(callrecordings_file_values)
    print(verified_clean_file_values)
    differences = list(set(callrecordings_file_values) - set(verified_clean_file_values))
    print(differences)
    print('differences count between callrecordings and verified_clean bucket files - ' + str(len(differences)))
    if(len(differences) > 1):
        s3_file_name = 'verified_clean_diff_files.csv'
        s3_client.put_object(Body=json.dumps(differences), Bucket=s3_bucket_name, Key=formatted_datetime+'/'+s3_file_name)   
    else:
        print("No differences in files in callrecordings and verified_clean bucket files")        