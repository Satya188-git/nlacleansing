locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  tags = {
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

module "layers" {
  source = "./layers"
}


# CustomerCallCenter-Lambda-Transcribe
module "ccc_transcribe_lambda" {
  depends_on       = [var.custom_transcribe_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "6.0.0-prerelease"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "transcribe"

  description                       = "nla transcribe source files lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.8"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 30
  cloudwatch_logs_tags              = local.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.transcribe_lambda_role_arn
  update_role                       = false

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc_transcribe_lambda.zip"
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
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-lambda-transcribe"
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
  version          = "6.0.0-prerelease"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "comprehend-lambda"

  description                       = "nla comprehend source files lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.8"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 30
  cloudwatch_logs_tags              = local.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.comprehend_lambda_role_arn
  update_role                       = false

  environment_variables = {
    Athena_Database                       = var.athena_database_name
    Athena_Output_Location                = "s3://${var.ccc_athenaresults_bucket_id}/"
    Athena_Table                          = var.nla_glue_table_name
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
    Retry_Count                           = 10
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc_comprehend_lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-comprehend"
    },
  )
}

# CustomerCallCenter-Lambda-MacieInformational
module "ccc_informational_macie_lambda" {
  depends_on       = [var.informational_macie_lambda_role_arn, module.layers.ccc_informational_macie_lambda_id]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "6.0.0-prerelease"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "info-macie-lambda"

  description                       = "nla transcribed data macie informational lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.8"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 30
  cloudwatch_logs_tags              = local.tags
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
    CLEANED_BUCKET_NAME	             = var.ccc_cleaned_bucket_id
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc_informational_macie_lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-info-macie"
    },
  )
}


# aws-controltower-NotificationForwarder
module "ccc_notification_forwarder_lambda" {
  depends_on                        = [var.sns_lambda_role_arn]
  source                            = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version                           = "6.0.0-prerelease"
  company_code                      = local.company_code
  application_code                  = local.application_code
  environment_code                  = local.environment_code
  region_code                       = local.region_code
  application_use                   = "notification-lambda"
  kms_key_arn                       = var.kms_key_ccc_sns_lambda_arn
  description                       = "nla sns notification lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.8"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 30
  cloudwatch_logs_tags              = local.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.sns_lambda_role_arn
  update_role                       = false

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc_notification_forwarder_lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-notification"
    },
  )
}

# Trigger-Macie-Scan
module "ccc_macie_scan_trigger_lambda" {
  depends_on       = [var.trigger_macie_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "6.0.0-prerelease"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "macie-scan-lambda"

  description                       = "nla trigger of macie scan lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.8"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 30
  cloudwatch_logs_tags              = local.tags
  memory_size                       = 128
  timeout                           = 180
  reserved_concurrent_executions    = 100
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.trigger_macie_lambda_role_arn
  update_role                       = false

  environment_variables = {
    BUCKET_NAME                     = var.ccc_cleaned_bucket_id
    ACCOUNT_ID                      = var.account_id
    CLIENT_TOKEN                    = "d7db50c1-faab-42a8-9d8e-8ba23644e446"
    JOB_TYPE                        = "ONE_TIME"
    MANAGE_DATA_IDENTIFIER_SELECTOR = "ALL"
    SAMPLING_PERCENTAGE             = "100"
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc_macie_scan_trigger_lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-macie-scan"
    },
  )
}

module "ccc_audit_call_lambda" {
  depends_on       = [var.audit_call_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "6.0.0-prerelease"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "audit-call-lambda"

  description                       = "nla audit lambda"
  handler                           = "run.lambda_handler"
  runtime                           = "python3.8"
  publish                           = true
  architectures                     = ["x86_64"]
  attach_tracing_policy             = true
  attach_dead_letter_policy         = true
  attach_cloudwatch_logs_policy     = true
  cloudwatch_logs_retention_in_days = 30
  cloudwatch_logs_tags              = local.tags
  memory_size                       = 128
  timeout                           = 180
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.audit_call_lambda_role_arn
  update_role                       = false

  environment_variables = {
    CLEANED_BUCKET_NAME          = var.ccc_cleaned_bucket_id
    CLEANED_VERIFIED_BUCKET_NAME = var.ccc_verified_clean_bucket_id
    DIRTY_BUCKET_NAME            = var.ccc_dirty_bucket_id
    TABLE_NAME                   = var.dynamodb_audit_table_name
    TRANSCRIPTION_BUCKET_NAME    = var.ccc_initial_bucket_id
    UNREFINED_BUCKET_NAME        = var.ccc_unrefined_call_data_bucket_id
    DEBUG                        = "disabled"
    ENV                          = var.environment_code
  }
  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc_audit_call_lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-audit-call"
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
  source_arn     = var.customercallcenterpiimaciescan_s3_event_rule_arn
  source_account = var.account_id
}
