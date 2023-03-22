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
  depends_on       = [var.transcribe_lambda_role_arn]
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.transcribe_lambda_role_arn
  update_role                       = false

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-transcribe-lambda.zip"
  }

  environment_variables = {
    CONF_DESTINATION_BUCKET_NAME = var.ccc_initial_bucket_id
    CONF_S3BUCKET_OUTPUT         = var.ccc_unrefined_call_data_bucket_id
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.comprehend_lambda_role_arn
  update_role                       = false

  environment_variables = {
    CLEANED_BUCKET_NAME = var.ccc_cleaned_bucket_id
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-comprehend-lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-comprehend"
    },
  )
}

# CustomerCallCenter-Lambda-MacieInformational
module "ccc_informational_macie_lambda" {
  depends_on       = [var.informational_macie_lambda_role_arn]
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.comprehend_lambda_role_arn
  update_role                       = false

  environment_variables = {
    DESTINATION_BUCKET_NAME_VERIFIED = var.ccc_verified_clean_bucket_id
    DESTINATION_BUCKET_NAME_DIRTY    = var.ccc_dirty_bucket_id
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-informational-macie-lambda.zip"
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.sns_lambda_role_arn
  update_role                       = false

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-notification-forwarder-lambda.zip"
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.trigger_macie_lambda_role_arn
  update_role                       = false

  environment_variables = {
    SCAN_BUCKET_NAME_VERIFIED = var.ccc_cleaned_bucket_id
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-macie-scan-trigger-lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-macie-scan"
    },
  )
}

# CustomerCallCenter-Lambda-Macie
module "ccc_macie_lambda" {
  depends_on       = [var.macie_lambda_role_arn]
  source           = "app.terraform.io/SempraUtilities/seu-lambda/aws"
  version          = "6.0.0-prerelease"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "macie-lambda"

  description                       = "nla macie lambda"
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.macie_lambda_role_arn
  update_role                       = false
  environment_variables = {
    TARGET_BUCKETS_LIST = var.ccc_cleaned_bucket_id
  }

  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-macie-lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-macie"
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

  description                       = "nla macie lambda"
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
  timeout                           = 3
  tracing_mode                      = "PassThrough"
  lambda_role                       = var.audit_call_lambda_role_arn
  update_role                       = false


  s3_existing_package = {
    bucket = var.tf_artifact_s3
    key    = "ccc-audit-call-lambda.zip"
  }

  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-audit-call"
    },
  )
}
