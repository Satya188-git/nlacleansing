locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  # tags = {
  #   "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
  #   billing-guid        = var.billing-guid
  #   portfolio           = var.portfolio
  #   support-group       = var.support-group
  #   "sempra:gov:environment" = var.environment 	# environment         = var.environment
  #   "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
  #   data-classification = var.data-classification
	# "sempra:gov:unit"   = var.unit 				# unit                = var.unit
  # }
}

data "aws_default_tags" "aws_tags" {}

module "layers" {
  source = "./layers"
}

# CustomerCallCenter-Lambda-Transcribe
module "ccc_transcribe_lambda" {
  depends_on       = [var.custom_transcribe_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "transcribe"

  description                       = "nla transcribe source files lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.transcribe_lambda_role_arn
  update_role                       = false

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_transcribe_lambda.zip"
  }

  environment_variables = {
    CONF_API_MODE                   = "standard"
    CONF_DESTINATION_BUCKET_NAME    = var.ccc_initial_bucket_id
    CONF_FILTER_NAME                = "TestVocabFilter1"
    CONF_MAX_SPEAKERS               = "2"
    CONF_REDACTION_LANGS            = "en-US"
    CONF_REDACTION_TRANSCRIPT       = "true"
    CONF_ROLE_ARN                   = var.custom_transcribe_lambda_role_arn
    CONF_S3BUCKET_OUTPUT            = var.ccc_unrefined_call_data_bucket_id
    CONF_S3BUCKET_OUTPUT_SUB_FOLDER = "standard/"
    CONF_SPEAKER_MODE               = "channel"
    CONF_TRANSCRIBE_LANG            = "en-US"
    KEY                             = "billing-guid"
    VALUE                           = var.billing-guid
    audit_lambda_arn					      =   module.ccc_audit_call_lambda.lambda_function_arn

  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-lambda-transcribe"
    },
  )
  allowed_triggers = {
    AllowExecutionFromS3Bucket = {
      principal  = "s3.amazonaws.com"
      source_arn = var.ccc_unrefined_call_data_bucket_arn
    }
  }
}

# CustomerCallCenter-Lambda-Comprehend
module "ccc_comprehend_lambda" {
  depends_on       = [var.comprehend_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "comprehend"

  description                       = "nla comprehend source files lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.comprehend_lambda_role_arn
  update_role                       = false

  environment_variables = {
    Athena_Output_Location                = "s3://${var.ccc_athenaresults_bucket_id}/"
    Athena_Table                          = var.nla_glue_table_name
    Table_Name                            = var.nla_glue_table_name
    DB_Name                               = var.nla_glue_database_name
    STANDARD_FULL_TRANSCRIPT_SUB_FOLDER   = "standard_full_transcripts/"
    STANDARD_FULL_TRANSCRIPT_FILE_FORMAT  = ".txt"
    STANDARD_FULL_TRANSCRIPT_CONTENT_TYPE = "text/plain"
    DF_COMPANY_NAME                       = "SDG&E"
    OUTPUT                                = var.ccc_athenaresults_bucket_arn
    CLEANED_BUCKET_NAME                   = var.ccc_cleaned_bucket_id
    EBBilling_NAME                        = "EBBilling"
    EBBilling_VECTOR_ID                   = "1245654"
    EBCSR_NAME                            = "EBCSR"
    EBCSR_VECTOR_ID                       = "1245610"
    EBMove_NAME                           = "EBMove"
    EBMove_VECTOR_ID                      = "1245655"
    ERBilling_NAME                        = "ERBilling"
    ERBilling_VECTOR_ID                   = "1245667"
    ERCredit_NAME                         = "ERCredit"
    ERCredit_VECTOR_ID                    = "1245616"
    ERCSR_NAME                            = "ERCSR"
    ERCSR_VECTOR_ID                       = "1245602"
    ERMove_NAME                           = "ERMove"
    ERMove_VECTOR_ID                      = "1245668"
    EBHighBill_NAME                       = "EBHighBill"
    EBHighBill_VECTOR_ID                  = "1245656"
    ERHighBill_NAME                       = "ERHighBill"
    ERHighBill_VECTOR_ID                  = "1245640"
    Outage_NAME                           = "EnOutage"
    Outage_VECTOR_ID                      = "1245645"
    ERMyAccount_NAME	                    = "ERMy Account"
    ERMyAccount_VECTOR_ID	                = "1245153"
    ERSolar_NAME	                        = "ERSolar"
    ERSolar_VECTOR_ID	                    = "1245670"  
    Emergency_NAME                        = "EnEmergency"
    Emergency_VECTOR_ID                   = "1245624"
    EV_NAME                               = "ERElectric Vehicle"
    EV_VECTOR_ID                          = "1245671"
    Retry_Count                           = 10
    audit_lambda_arn					            =   module.ccc_audit_call_lambda.lambda_function_arn
    PHONENO_SECRET_KEY                    = "ccc$ecretK3y!"
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_comprehend_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-comprehend"
    },
  )
}

# CustomerCallCenter-Lambda-MacieInformational
module "ccc_informational_macie_lambda" {
  depends_on       = [var.informational_macie_lambda_role_arn, module.layers.ccc_informational_macie_lambda_id]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "info-macie"

  description                       = "nla transcribed data macie informational lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.comprehend_lambda_role_arn
  update_role                       = false

  environment_variables = {
    DESTINATION_BUCKET_NAME_VERIFIED = var.ccc_verified_clean_bucket_id
    DESTINATION_BUCKET_NAME_DIRTY    = var.ccc_dirty_bucket_id
    TRANSCRIPTION_BUCKET_NAME        = var.ccc_initial_bucket_id
    UNREFINED_BUCKET_NAME            = var.ccc_unrefined_call_data_bucket_id
    FINAL_OUTPUTS_FOLDER             = "final_outputs"
    CLEANED_BUCKET_NAME              = var.ccc_cleaned_bucket_id
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_informational_macie_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-info-macie"
    },
  )
}


module "ccc_notification_forwarder_lambda" {
  depends_on                        = [var.sns_lambda_role_arn]
  source                            = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version                           = "10.0.0"
  company_code                      = local.company_code
  application_code                  = local.application_code
  environment_code                  = local.environment_code
  region_code                       = local.region_code
  application_use                   = "notification"
  kms_key_arn                       = var.kms_key_ccc_sns_lambda_arn
  description                       = "nla sns notification lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.sns_lambda_role_arn
  update_role                       = false

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_notification_forwarder_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-notification"
    },
  )
}

# Trigger-Macie-Scan
module "ccc_macie_scan_trigger_lambda" {
  depends_on       = [var.trigger_macie_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "macie-scan"

  description                       = "nla trigger of macie scan lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.trigger_macie_lambda_role_arn
  update_role                       = false

  environment_variables = {
    BUCKET_NAME                     = var.ccc_cleaned_bucket_id
    ACCOUNT_ID                      = var.account_id
    JOB_TYPE                        = "ONE_TIME"
    MANAGE_DATA_IDENTIFIER_SELECTOR = "ALL"
    SAMPLING_PERCENTAGE             = "100"
    audit_lambda_arn					      =   module.ccc_audit_call_lambda.lambda_function_arn

  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_macie_scan_trigger_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-macie-scan"
    },
  )
}

module "ccc_audit_call_lambda" {
  depends_on       = [var.audit_call_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "audit-call"

  description                       = "nla audit lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.audit_call_lambda_role_arn
  update_role                       = false

  environment_variables = {
    CLEANED_BUCKET_NAME          = var.ccc_cleaned_bucket_id
    CLEANED_VERIFIED_BUCKET_NAME = var.ccc_verified_clean_bucket_id
    DIRTY_BUCKET_NAME            = var.ccc_dirty_bucket_id
    TABLE_NAME                   = var.dynamodb_nla_audit_table_name
    TRANSCRIPTION_BUCKET_NAME    = var.ccc_initial_bucket_id
    UNREFINED_BUCKET_NAME        = var.ccc_unrefined_call_data_bucket_id
    AUDIO_BUCKET_NAME            = var.ccc_insights_audio_bucket_id
    CALL_RECORDINGS_BUCKET_NAME  = var.ccc_callrecordings_bucket_id
    METADATA_BUCKET_NAME         = var.ccc_piimetadata_bucket_id
    DEBUG                        = "disabled"
    ENV                          = var.environment_code
  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_audit_call_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-audit-call"
    },
  )
}

module "ccc_audio_copy_lambda" {
  depends_on       = [var.audit_call_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "audio-copy"

  description                       = "nla audio copy lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.audio_copy_lambda_role_arn
  update_role                       = false

  environment_variables = {
    AUDIO_BUCKET           = var.ccc_unrefined_call_data_bucket_id
    CALL_RECORDINGS_BUCKET = var.ccc_callrecordings_bucket_id
    EDIX_AUDIO_DIR         = "EDIX_AUDIO"
    DEBUG                  = "disabled"
    ENV                    = var.environment_code
  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_audio_copy.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-audio-copy"
    },
  )
}

# Lambda for file transfer
module "ccc_file_transfer_lambda" {
  depends_on       = [var.file_transfer_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "file-transfer"

  description                       = "nla file transfer lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.file_transfer_lambda_role_arn
  update_role                       = false

  environment_variables = {
    DESTINATION_BUCKET           = ""
    KEYS_TO_COPY                 = ""
    DELETE_MARKER                = ""
    SOURCE_BUCKET                = ""

  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_file_transfer_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-file-transfer"
    },
  )
}

# Lambda for key rotation alert
module "key_rotation_alert_lambda" {
  depends_on       = [var.key_rotation_alert_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "key-rotation-alert"

  description                       = "key rotation alert lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.key_rotation_alert_lambda_role_arn
  update_role                       = false

  environment_variables = {
    ROTATION_ALERT_SNS_ARN = var.key_rotation_sns_arn
    REGION                 = var.region
  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/key_rotation_alert_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-key-rotation-alert"
    },
  )
}

# Lambda for forwarding call audio s3 access logs to CW logs
module "ccc_audio_access_logs_to_cw_lambda" {
  depends_on       = [var.ccc_audio_access_logs_to_cw_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "audio-access-logs-to-cw"

  description                       = "forwarding call audio s3 access logs to CW logs"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.ccc_audio_access_logs_to_cw_lambda_role_arn
  update_role                       = false

  environment_variables = {
    LOG_GROUP           = var.callaudioaccess_log_group_name
    LOG_STREAM 			= "logstream"
    DEBUG               = "disabled"
    ENV                 = var.environment_code
  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_audio_access_logs_to_cw.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-audio-access-logs-to-cw"
    },
  )
}

# Lambda to send email notification upon unauthorized download/access.
module "ccc_access_denied_notification_lambda" {
  depends_on       = [var.ccc_access_denied_notification_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "access-denied-notification"

  description                       = "Sending sns notification for s3 access denied logs"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.11"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 180
  cloudwatch_logs_tags              = data.aws_default_tags.aws_tags.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.ccc_access_denied_notification_lambda_role_arn
  update_role                       = false

  environment_variables = {
    SNS_TOPIC_ARN           = var.access_denied_notification_topic_arn
    LOG_STREAM 			= "logstream"
    DEBUG               = "disabled"
    ENV                 = var.environment_code
  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "pipeline-artifact/ccc_access_denied_notification_lambda.zip"
  }

  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-access-denied-notification"
    },
  )
}

# Permissions for EventBridge
resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_comprehend_lambda" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_comprehend_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiitranscription_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda1" {
  statement_id   = "AllowExecutionFromCloudWatch1"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiitranscription_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda2" {
  statement_id   = "AllowExecutionFromCloudWatch2"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiicleanedverified_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda3" {
  statement_id   = "AllowExecutionFromCloudWatch3"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiiunrefined_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_transcribe_lambda" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_transcribe_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiiunrefined_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda4" {
  statement_id   = "AllowExecutionFromCloudWatch4"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiicleaned_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda5" {
  statement_id   = "AllowExecutionFromCloudWatch5"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.callrecordings_audio_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda6" {
  statement_id   = "AllowExecutionFromCloudWatch6"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.callrecordings_metadata_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda7" {
  statement_id   = "AllowExecutionFromCloudWatch7"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.pii_metadata_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audit_call_lambda8" {
  statement_id   = "AllowExecutionFromCloudWatch8"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audit_call_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.audio_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_macie_info_lambda4" {
  statement_id   = "AllowExecutionFromCloudWatch4"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_informational_macie_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiimacieinfo_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_macie_scan_lambda4" {
  statement_id   = "AllowExecutionFromCloudWatch4"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_macie_scan_trigger_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.customercallcenterpiimaciescanscheduler_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audio_copy_lambda" {
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audio_copy_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.ccc_audio_copy_s3_event_rule_arn
  source_account = var.account_id
}


resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_audio_access_logs_to_cw_lambda" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_audio_access_logs_to_cw_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.ccc_audio_access_logs_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ccc_access_denied_notification_lambda" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = module.ccc_access_denied_notification_lambda.lambda_function_name
  principal      = "events.amazonaws.com"
  source_arn     = var.ccc_access_denied_notification_logs_s3_event_rule_arn
  source_account = var.account_id
}

resource "aws_lambda_permission" "allow_EventbridgeScheduler_invoke_keyrotationalert_lambda" {
  statement_id  = "AllowExecutionFromEventbridgeScheduler"
  action        = "lambda:InvokeFunction"
  function_name = module.key_rotation_alert_lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.key_rotation_alert_lambda_scheduler_rule_arn
}