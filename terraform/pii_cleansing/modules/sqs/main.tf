locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  owner            = var.owner
  tags = {
    "sempra:gov:tag-version" = var.tag-version 	# tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    "sempra:gov:unit"   = var.unit 				# unit                = var.unit
    portfolio           = var.portfolio
    support-group       = var.support-group
    "sempra:gov:environment" = var.environment 	# environment         = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

module "sqs_historical_etl_output" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "10.0.0" # "4.0.1"
  aws_region       = local.region
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_name = "historical-dataloader-q"
  message_retention_seconds = "864000"
  visibility_timeout_seconds = "300"  
  # kms_master_key_id = var.kms_key_sqs_key_id
  # kms_data_key_reuse_period_seconds = 300
  tags = merge(local.tags,
  {
    "sempra:gov:name" = "${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-${var.application_use}-sqs-dataloader-dlq"
  })
}

resource "aws_sqs_queue_policy" "sqs_historical_etl_output_access" {
  queue_url = module.sqs_historical_etl_output.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.account_id}:root",
          "arn:aws:iam::${var.insights_account_id}:root"
        ]
      },
      "Action": "SQS:*",
      "Resource": "${module.sqs_historical_etl_output.arn}"
    }
  ]
}
POLICY
}