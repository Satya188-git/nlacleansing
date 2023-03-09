import datetime
import json
import re
import uuid
#import nltk

import time
import boto3


from datetime import datetime


DF_COMPANY_NAME = 'SDG&E'

#------------------------------------------------------------------------------#
def read_output_standard(json_content, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER):
	
	data = json_content
	
	# using this condition to make sure the voice call was not empty
	if 'speaker_labels' in data['results']:

		labels = data['results']['speaker_labels']['segments']
		speaker_start_times={}
		
		print("we got in")
		
	  
		for label in labels:
			for item in label['items']:
				speaker_start_times[item['start_time']] = item['speaker_label']      
			
		items = data['results']['items']
		lines = []
		line = ''
		time = 0
		speaker = 'null'
		i = 0
	     
		# loop through all elements
		for item in items:
			i = i+1
			content = item['alternatives'][0]['content']
			
			# if it's starting time
			if item.get('start_time'):
				current_speaker = speaker_start_times[item['start_time']]
	
			# in AWS output, there are types as punctuation
			elif item['type'] == 'punctuation':
				line = line + content
	
			# handle different speaker
			if current_speaker != speaker:
				if speaker:
					
					#replace the speaker name and add to the line
					new_speaker = replace_speaker_name(speaker, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER)
					#print("New Speaker:", new_speaker)
					lines.append({'speaker':new_speaker, 'line':line, 'time':time})
				line = content
				speaker = current_speaker
				time = item['start_time']        
			elif item['type'] != 'punctuation':
				line = line + ' ' + content
		
		
		# sort the results by the time
		sorted_lines = sorted(lines,key=lambda k: float(k['time']))
			
		# constructing the results
		results = ""
		for line_data in sorted_lines:
			
			#line = '[' + str(datetime.timedelta(seconds=int(round(float(line_data['time']))))) + '] ' + line_data.get('speaker') + ': ' + line_data.get('line')
			line = line_data.get('speaker') + ': ' + line_data.get('line')
	
			#print(line)
			results = results + line + "\n"
	else:
		results = ""


	return results
	

#----------------------------------------------------------#
#replacing the speaker names with (AGENT, CUSTOMER) values

def replace_speaker_name(speaker, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER):

	# Example:
	# CHANNEL_ID_AGENT = 0
	# CHANNEL_ID_CUSTOMER = 1		

	new_speaker = ''
	if speaker == 'spk_0':
		if CHANNEL_ID_AGENT == 0:
			new_speaker = 'AGENT'
		else:
			new_speaker = 'CUSTOMER'
			
	elif speaker == 'spk_1':
		if CHANNEL_ID_AGENT == 1:
			new_speaker = 'AGENT'
		else:
			new_speaker = 'CUSTOMER'
	
	return new_speaker


#----------------------------------------------------------#
# Converting the output of Call Analytics API into Transcript
	
def read_output_callanalytics(json_content):
	
	full_transcript = ''
	for tran in json_content["Transcript"]:
		full_transcript = full_transcript + "\n" + tran["ParticipantRole"] + ": " + tran["Content"]

	return full_transcript
	
#----------------------------------------------------------#
# Cleaning of Standard output and keeping the  JSON format

def perform_pi_redaction_standard(comprehend, s3client, s3filename, cleaned_bucket_name, content):
	
	
	transcripts = content["results"]["transcripts"]
	
	for i in range(len(transcripts)):
		
		trans = transcripts[i]["transcript"]
	
	
		# send to comprehend to clean 
		cleaned_trans = comprehend_content_cleaning(comprehend, trans)
		
		# performing Regex based cleaning
		cleaned_trans2 = regex_content_cleaning(cleaned_trans)

		# storing the redacted results
		transcripts[i]["transcript"] = cleaned_trans2

	cleaned_content = content
	cleaned_content["results"]["transcripts"] = transcripts

	# Save the CLEANED content to S3
	s3_path =  "standard/" + s3filename + "_cleaned.json"
	response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=(bytes(json.dumps(cleaned_content, indent=4).encode('UTF-8'))), ContentType='text/plain')

	
#----------------------------------------------------------#
# Cleaning of Call Analytics output and keeping the  JSON format

def perform_pi_redaction_callanalytics(comprehend, s3client, s3filename, cleaned_bucket_name, content):

	 
	transcripts = content["Transcript"]
	
	for i in range(len(transcripts)):
		
		trans = transcripts[i]["Content"]
	
		# detect sentiment
		sentiment_value, sentiment_score = comprehend_content_sentiment(comprehend, trans)
	
		# send to comprehend to clean
		cleaned_trans = comprehend_content_cleaning(comprehend, trans)
		
		# performing Regex based cleaning
		cleaned_trans2 = regex_content_cleaning(cleaned_trans)
		
		# storing the redacted results
		transcripts[i]["Content"] = cleaned_trans2
		
		# storing the sentiments
		transcripts[i]["Comprehend_Sentiment"] = sentiment_value
		transcripts[i]["Comprehend_Sentiment_Score"] = sentiment_score

	# Adding the changed content back to main JSON object
	cleaned_content = content
	cleaned_content["Transcript"] = transcripts
	
	# Save the CLEANED content to S3
	s3_path =  "analytics/" + s3filename + "_cleaned.json"
	response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=(bytes(json.dumps(cleaned_content, indent=4).encode('UTF-8'))), ContentType='text/plain')


#----------------------------------------------------------#
# Cleaning of Call Analytics output and keeping the  JSON format

def perform_pi_redaction_full_transcript(comprehend, s3client, s3filename, cleaned_bucket_name, content):
	

	#print(content)

	# send to comprehend to detect PIIs 
	cleaned_content = comprehend_content_cleaning(comprehend, content)
	#print("Content after cleaning: ", content)

	# performing Regex based cleaning
	cleaned_content2 = regex_content_cleaning(cleaned_content)
		
		
	# Save the CLEANED content to S3
	s3_path =  "standard_full_transcripts/" + s3filename + "_full_transcript_cleaned.json"
	response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=cleaned_content2, ContentType='text/plain')
	
	

#---------------------------------------------------------------#
# function to clean based on REGEX

def regex_content_cleaning(content):

	# Regex 1
	regex1 = re.compile(r"([A-Z]{1}\.?\s){3,}")
	cleaned_content = regex1.sub("NAME_SPELLING ", content)
	cleaned_content = re.sub(r'\w*NAME_SPELLING\w*', 'NAME_SPELLING', cleaned_content, flags=re.IGNORECASE)

	# Regex 2 for 3 digit numbers 'this is s12a and 1. for is123 or 1 or one' TO 'this is DIGITS and DIGITS. for DIGITS or DIGITS or one'
	regex2 = re.compile(r"\d{3,}")
	cleaned_content = regex2.sub("DIGITS", cleaned_content)
	cleaned_content = re.sub(r'\w*DIGITS\w*', 'DIGITS', cleaned_content, flags=re.IGNORECASE)
	
	# Regex 3 for more than 1 digit 'this is s12a and 1. for is123 or 1 or one' TO 'this is DIGITS and DIGITS. for DIGITS or DIGITS or one'
	regex3 = re.compile(r"[0-9]+")
	cleaned_content = regex3.sub("DIGITS", cleaned_content)
	cleaned_content = re.sub(r'\w*DIGITS\w*', 'DIGITS', cleaned_content, flags=re.IGNORECASE)


    # Regex 3
    # ...
    
	return cleaned_content


#---------------------------------------------------------------#
# function to clean the PI from content

def comprehend_content_cleaning(comprehend, content):
	
	cleaned_content = content
	if len(cleaned_content)>0:

		# send to comprehend to detect PIIs 
		comprehend_pii_response = comprehend.detect_pii_entities(
			Text= cleaned_content,
			LanguageCode='en'
		)
	         # we are not able to pass any TAGS with this request

		# Replacing the PII with PII Type name
		for NER in reversed(comprehend_pii_response['Entities']):
			cleaned_content = cleaned_content[:NER['BeginOffset']] + NER['Type'] + cleaned_content[NER['EndOffset']:]
		     	# reversed to not modify the offsets of other entities when substituting
	
		# send to comprehend to detect the ENTITIES
		comprehend_entitites_response = comprehend.detect_entities (
		 	Text = cleaned_content,
			LanguageCode = 'en'
		)
			# we are not able to pass any TAGS with this request
	
		# Replacing the PI with Entity Type name
		for NER in reversed(comprehend_entitites_response['Entities']):
			cleaned_content = cleaned_content[:NER['BeginOffset']] + NER['Type'] + cleaned_content[NER['EndOffset']:]
				# reversed to not modify the offsets of other entities when substituting
				
	return cleaned_content


#---------------------------------------------------------------#
# function to generate sentiment from content

def comprehend_content_sentiment(comprehend, content):
	
	sentiment_value = ''
	sentiment_score = ''
	
	if len(content)>250:
		content = content[:250]	

	if len(content)>0:
		# detect sentiment
		comprehend_sentiment_response = comprehend.detect_sentiment(
			Text= content,
			LanguageCode='en'
		)
		
		sentiment_value = comprehend_sentiment_response['Sentiment']
		sentiment_score = comprehend_sentiment_response['SentimentScore']

	return sentiment_value, sentiment_score





#----------------------------------------------------------------#
# Function to capture metadata of the file using Athena Queries

def capture_file_metdadata(s3filename):
	
	# This function will be called by "capture_file_data" 
	# it queries the metadata folder in S3 for call metadata
	
	query = 'SELECT * FROM default.ccc_metadata'
	
	query = """
			SELECT 
			    \"full Name\" as \"fullName\",
			    \"participant agent id\" as \"participantAgentId\",
			    \"segment call direction type id\" as \"segmentCallDirectionTypeId\",
			    \"participant phone-number\" as \"participantPhoneNumber\",
			    \"segment id\" as \"segmentID\",
			    \"segment dialed number\" as \"segmentDialedNumber\",
			    \"segment start time\" as \"segmentStartTime\",
			    \"segment stop time\" as \"segmentStopTime\" ,
			    \"segment vector number\" as \"segmentVectorNumber\",
			    \"internal segment client start time\" as \"internalSegmentClientStartTime\",
			    \"internal segment client stop time\" as \"internalSegmentClientStopTime\"
			FROM \"default\".\"ccc-metadata-3\"
			where \"file Name\" = '""" + s3filename + "';"
			
	print("query:", query)		
	
	#query = "SELECT * FROM default.ccc-metadata-3 limit 10";		
	
	DATABASE = 'default'
	output='s3://customercallcenterathenaresults/'
	
	client = boto3.client('athena')
	
    # Execution
	response = client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': DATABASE
        },
        ResultConfiguration={
            'OutputLocation': output
        }
    )

	# get query execution id
	query_execution_id = response['QueryExecutionId']
	print(query_execution_id)

	# number of retries
	RETRY_COUNT = 10
	
	# get execution status
	for i in range(1, 1 + RETRY_COUNT):

		# get query execution
		query_status = client.get_query_execution(QueryExecutionId=query_execution_id)
		query_execution_status = query_status['QueryExecution']['Status']['State']

		if query_execution_status == 'SUCCEEDED':
			print("STATUS:" + query_execution_status)
			break

		if query_execution_status == 'FAILED':
			raise Exception("STATUS:" + query_execution_status)

		else:
			print("STATUS:" + query_execution_status)
			time.sleep(i)
	else:
		client.stop_query_execution(QueryExecutionId=query_execution_id)
		raise Exception('TIME OVER')

	# get query results

	result = client.get_query_results(QueryExecutionId=query_execution_id)
	print("result *******************************")
	print(result)
	# This is the order of values 
	# "full Name" as "fullName",
	# "participant agent id" as "participantAgentId",
	# "segment call direction type id" as "segmentCallDirectionTypeId",
	# "participant phone-number" as "participantPhoneNumber",
	# "segment id" as "segmentID",
	# "segment dialed number" as "segmentDialedNumber",
	# "segment start time" as "segmentStartTime",
	# "segment stop time" as "segmentStopTime" ,
	# "segment vector number" as "segmentVectorNumber",
	# "internal segment client start time" as "internalSegmentClientStartTime",
	# "internal segment client stop time" as "internalSegmentClientStopTime"

	data = result["ResultSet"]["Rows"][1]["Data"]
	print("Datas is this ", data)

	# Generating the time delta
	# Sample timestamp: '2021-06-02T07:42:33.2700000'
	s1 = re.findall( "(.*)\..*", data[9]['VarCharValue'])[0]
	s2 = re.findall( "(.*)\..*", data[10]['VarCharValue'])[0]
	
	FMT = "%Y-%m-%dT%H:%M:%S"
	time_delta = datetime.strptime(s2, FMT) - datetime.strptime(s1, FMT)


	# process the customer phone number
	customer_phone_obfuscated = uuid.uuid3(uuid.NAMESPACE_DNS, data[3]['VarCharValue']).hex
	customer_area_code = data[3]['VarCharValue'][1:4]
	
	result_dict = {}
	result_dict["companyName"] = DF_COMPANY_NAME # DF_COMPANY_NAME = SDG&E
	result_dict["fileID"] = data[4]['VarCharValue']
	result_dict["fileName"] = s3filename
	result_dict["fullName"] = data[0]['VarCharValue'].strip()
	result_dict["participantAgentId"] = data[1]['VarCharValue']
	result_dict["segmentCallDirectionTypeId"] = data[2]['VarCharValue']
	result_dict["participantPhoneNumber"] = customer_phone_obfuscated
	result_dict["participantAreaCode"] = customer_area_code
	result_dict["segmentID"] = data[4]['VarCharValue']
	result_dict["segmentDialedNumber"] = data[5]['VarCharValue']
	result_dict["segmentStartTime"] = data[6]['VarCharValue']
	result_dict["segmentStopTime"] = data[7]['VarCharValue']
	result_dict["segmentVectorNumber"] = data[8]['VarCharValue']
	result_dict["internalSegmentClientStartTime"] = data[9]['VarCharValue']
	result_dict["internalSegmentClientStopTime"] = data[10]['VarCharValue']
	result_dict["callLengthSeconds"] = str(time_delta.seconds)
	
	####################################
	# Capturing the Call Type information
	# s3filename1 = "InnPOC_EBHB_1245656_6968917624718701096_Summed.wav"
	# call_type1 = re.findall(".*_([A-Z]{4})_.*", s3filename1)
	# print("call_type1 *************")
	# print(call_type1)	
	# call_type = re.findall(".*_([A-Z]{4})_.*", s3filename)
	# print("call_type *************")
	# print(call_type)
	# call_type = str(call_type[0])
	
	# # capturing the language
	# if call_type[0] == 'E':
	# 	call_languauge = 'English'
	# elif call_type[0] == 'S':
	# 	call_languauge = 'Spanish'
	# else:
	# 	call_languauge == call_type[0]
	
	# # Capturing the Customer Type
	# if call_type[1] == "B":
	# 	customer_type = "Business"
	# elif call_type[1] == "R":
	# 	customer_type = "Residential"
	# else:
	# 	customer_type = call_type[1]
		
	# # Capturing the Call Category
	# if call_type[2:4] == "HB":
	# 	call_category = "High Bill"
	# else:
	# 	call_category = call_type[2:4]
	
	# # Capturing the batch name
	# call_batch = re.findall("^(.*?)_.*", s3filename)
	# if call_batch:
	# 	call_batch = call_batch[0]
	# else:
	# 	call_batch = ''
	# s3filename = "NLA_1245669_7150299436568094190_Summed.wav"
	# call_type = re.findall(".*_([0-9]{7})_.*", s3filename)
	
	# vector_number = {'1245602': 'ERCSR', '1245667': 'ERBilling', '1245616': 'ERCredit', '1245668': 'ERMove'}
	
	# call_type = str(call_type[0])
	
	# try:
	#     call_type = (vector_number[call_type])
	# except KeyError:
	#     print('Business Type Not found')
	call_pattern = re.findall(".*_([0-9]{7})_.*", s3filename)
	call_pattern = str(call_pattern[0])

	if call_pattern == '1245602':
	    call_type = 'ERCSR'
	elif call_pattern == '1245667':
	    call_type = 'ERBilling'
	elif call_pattern == '1245616':
	    call_type = 'ERCredit'
	elif call_pattern == '1245668':
	    call_type = 'ERMove'
	else:
	    print("Invalid code/ Business Number")
	
	# capturing the language
	if call_type[0] == 'E':
	    call_languauge = 'English'
	elif call_type[0] == 'S':
	    call_languauge = 'Spanish'
	else:
	    call_languauge == call_type[0]
	
	
	# Capturing the Customer Type
	if call_type[1] == "B":
	    customer_type = "Business"
	elif call_type[1] == "R":
	    customer_type = "Residential"
	else:
	    customer_type = call_type[1]
	
	# Capturing the Call Category
	call_category = call_type[2:]
	
	# Capturing the batch name
	call_batch = re.findall("^(.*?)_.*", s3filename)
	if call_batch:
	    call_batch = call_batch[0]
	else:
	    call_batch = ''
	
	result_dict["language"] = call_languauge
	result_dict["customerType"] = customer_type
	result_dict["ivrCallCategory"] = call_category
	result_dict["batchName"] = call_batch

	return result_dict

#----------------------------------------------------------------#

def capture_file_data(s3filename):
	
	"""
	Naming convention of files:			"InnPOC_ERHB__1245640_6968884106793920414_Summed.wav"
	
	Components of name:
	
			-InnPOC
			 Name of rules and associated queries created in the NICE Extraction Toolkit (ETK)
			
			-ERHB  (residential)
			-EBHB  (business)
			 Call type is English Residential (ER) High Bill (HB)
			 
			 Call_Langauge = 'English'
			 Call_Type = "Business"
			 Call_IVR_Category = 'High Bill'
			 
			-Call Date
			
			-1245640
			 1245852
			 1245872
			 Segment Vector Number from NICE, describes what call path the customer was delivered to. Equivalent value of an Avaya Vector Directory Number (VDN)
			
			-6968884106793920414
			 Segment Identification generated by the NICE System for uniqueness
	"""
	
	
	# Capturing the batch name
	call_batch = re.findall("^(.*?)_.*", s3filename)
	if call_batch:
		call_batch = call_batch[0]
	else:
		call_batch = ''
	
	
	# Capturing the segment vector number
	call_seg_vector = re.findall(".*_(\d{7})_.*", s3filename)
	if call_seg_vector:
		call_seg_vector = call_seg_vector[0]
	else:
		call_seg_vector = ''
	
	# Capturing the CallID
	call_id = re.findall(".*_(\d+)_Summed.*", s3filename)
	if call_id:
		call_id = call_id[0]
	else:
		call_id = uuid.uuid1().node
		#call_id = uuid.uuid1().int
	
	# Capturing the Call Type information
	call_type = re.findall(".*_([A-Z]{4})_.*", s3filename)
	call_type = str(call_type[0])
	
	# capturing the language
	if call_type[0] == 'E':
		call_languauge = 'English'
	elif call_type[0] == 'S':
		call_languauge = 'Spanish'
	else:
		call_languauge == call_type[0]
	
	# Capturing the Customer Type
	if call_type[1] == "B":
		customer_type = "Business"
	elif call_type[1] == "R":
		customer_type = "Residential"
	else:
		customer_type = call_type[1]
		
	# Capturing the Call Category
	if call_type[2:4] == "HB":
		call_category = "High Bill"
	else:
		call_category = call_type[2:4]
		
	# Appending the call level information
	file_level_dict = {}
	file_level_dict["callID"] = call_id
	file_level_dict["callLength"] = "00:17:11"
	file_level_dict["language"] = call_languauge
	file_level_dict["customerType"] = customer_type
	file_level_dict["ivrCallCategory"] = call_category
	file_level_dict["batchName"] = call_batch
	file_level_dict["segmentVectorNumber"] = call_seg_vector
	file_level_dict["callTimestamp"] = "2022-02-03 12:13:19"
	
	return file_level_dict

#----------------------------------------------------------------#


def construct_final_output(comprehend, s3client, cleaned_bucket_name, s3filename, system_filename, content, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER):
	
	
	data = content
	
	lines = []
	# using this condition to make sure the voice call was not empty
	if 'speaker_labels' in data['results']:
		labels = data['results']['speaker_labels']['segments']
		speaker_start_times={}
		speaker_end_times={}
	  
	  
		# processing labels
		for label in labels:
			for item in label['items']:
				speaker_start_times[item['start_time']] = item['speaker_label']      
				speaker_end_times[item['end_time']] = item['speaker_label']      
			
		items = data['results']['items']
		
		line = ''
		start_time = 0
		end_time = 0
		speaker = 'null'
		i = 0
	
		# loop through all elements
		for item in items:
			i = i+1
			content = item['alternatives'][0]['content']
			
			# if it's starting time
			if item.get('start_time'):
				current_speaker = speaker_start_times[item['start_time']]
	
			# in AWS output, there are types as punctuation
			elif item['type'] == 'punctuation':
				line = line + content
	
			# handle different speaker 
			# this is where we are breaking the lines when ParticipantRole is changed
			if current_speaker != speaker:
				if speaker:
					#replace the speaker name and add to the line
					new_speaker = replace_speaker_name(speaker, CHANNEL_ID_AGENT, CHANNEL_ID_CUSTOMER)
					#print("New Speaker:", new_speaker)
					lines.append({'speaker':new_speaker, 'line':line, 'start_time': start_time, 'end_time': end_time})
				line = content
				speaker = current_speaker
				start_time = item['start_time']
				end_time = item['end_time']
			elif item['type'] != 'punctuation':
				line = line + ' ' + content
				end_time = item['end_time']
	
	
	# sort the results by the time
	sorted_lines = sorted(lines,key=lambda k: float(k['start_time']))
		
	# constructing the results
	results = {}
	
	# capturing the call level info
	#results["callLevelInformation"] = capture_file_data(s3filename)
	print("system_filename "+ system_filename)
	results["callLevelInformation"] = capture_file_metdadata(system_filename)

	
	# Capturing the medatadata info
	
	
	
	results["transcripts"] = []
	for line_data in sorted_lines:
		
		#line = '[' + str(datetime.timedelta(seconds=int(round(float(line_data['time']))))) + '] ' + line_data.get('speaker') + ': ' + line_data.get('line')
		#line = line_data.get('speaker') + ': ' + line_data.get('line')
		
		
		#{'speaker': 'AGENT', 'line': 'And could you please provide PFC information?', 
		#								'start_time': '390.47', 'end_time': '390.69'}


		# generating line sentiments & cleaning the content
		cleaned_content = comprehend_content_cleaning (comprehend, line_data['line'])
		sentiment_value, sentiment_score = comprehend_content_sentiment (comprehend, line_data['line'])
		# performing Regex based cleaning
		cleaned_content2 = regex_content_cleaning(cleaned_content)
		# generating sentiment average for sentences
		#generate_average_sentiments_per_sentences(comprehend, line_data['line'])

		# Generating line ID
		line_id = str(uuid.uuid4())
		
		line_dict = {}
		#line_dict["FileId"] = file_id
		#line_dict["CallType"] = call_type
		line_dict["lineId"] = line_id
		#line_dict["LoudnessScores"] = "LoudnessScores"
		line_dict["content"] = cleaned_content2
		line_dict["beginOffsetMillis"] = int(float(line_data['start_time']) * 1000)
		line_dict["endOffsetMillis"] = int(float(line_data['end_time']) * 1000)
		#line_dict["TranscribeSentiment"] = "Trascribe Sentiment"
		line_dict["sentiment"] = sentiment_value
		line_dict["sentimentScore"] = sentiment_score
		line_dict["participantRole"] = line_data['speaker']
		
		# added sentence wise aggregated sentiment value and score.
		#line_dict["Sentiment_Sentence"] = aggregated_sentiment_value
		#line_dict["SentimentScore_Sentence"] = aggregated_sentiment_score

		results["transcripts"].append(line_dict)
		print("*************************1***********************************")
	# Save the CLEANED content to S3
	s3_path =  "final_outputs/" + s3filename + "_final_output_cleaned.json"
	#response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=str(results), ContentType='text/plain')
	Body=str(json.dumps(results, indent=4))
	print("************************Body Indented*************************************")
	print(Body)
	print("cleaned_bucket_name"+cleaned_bucket_name)
	print("s3_path" + s3_path)
	response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=str(json.dumps(results, indent=4)), ContentType='text/plain')
	s3_path =  "final_outputs2/" + s3filename + "_final_output_cleaned.json"
	#response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=str(results), ContentType='text/plain')
	Body=str(json.dumps(results))
	print("************************Body Not Indented*************************************")
	print(Body)
	response = s3client.Bucket(cleaned_bucket_name).put_object(Key=s3_path, Body=str(json.dumps(results)), ContentType='text/plain')
	return results
	





