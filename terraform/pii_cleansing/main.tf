locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  owner            = var.owner
  account_id       = data.aws_caller_identity.current.account_id
  account_id_insights       = data.aws_caller_identity.nla-insights.account_id
  #account_id       = data.aws_caller_identity.nla-pii.account_id
  tags = {
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    unit                = var.unit
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

data "aws_caller_identity" "current" {}
# data "aws_caller_identity" "nla-pii" {
#   provider = aws.nla-pii
# }

data "aws_caller_identity" "nla-insights" {
  provider = aws.nla-insights
}

module "athena" {
  source                       = "./modules/athena"
  region                 = var.region
  environment            = var.environment
  application_use        = var.application_use
  namespace              = var.namespace
  company_code           = var.company_code
  application_code       = var.application_code
  environment_code       = var.environment_code
  region_code            = var.region_code
  owner                  = var.owner
  tag-version            = var.tag-version
  billing-guid           = var.billing-guid
  unit                   = var.unit
  portfolio              = var.portfolio
  support-group          = var.support-group
  cmdb-ci-id             = var.cmdb-ci-id
  data-classification    = var.data-classification
  ccc_athenaresults_bucket_id  = module.s3.ccc_athenaresults_bucket_id
  ccc_athenaresults_bucket_arn = module.s3.ccc_athenaresults_bucket_arn
  athena_kms_key_arn           = module.kms.athena_kms_key_arn
}

module "eventbridge" {
  source                          = "./modules/eventbridge"
  region                     = var.region
  environment                = var.environment
  application_use            = var.application_use
  company_code               = var.company_code
  application_code           = var.application_code
  environment_code           = var.environment_code
  owner                      = var.owner
  namespace                  = var.namespace
  region_code                = var.region_code
  tag-version                = var.tag-version
  billing-guid               = var.billing-guid
  unit                       = var.unit
  portfolio                  = var.portfolio
  support-group              = var.support-group
  cmdb-ci-id                 = var.cmdb-ci-id
  data-classification        = var.data-classification
  comprehend_lambda_arn      = module.lambda.comprehend_lambda_arn
  ccc_initial_bucket_id      = module.s3.ccc_initial_bucket_id
  ccc_audit_call_lambda_arn  = module.lambda.ccc_audit_call_lambda_arn
  ccc_unrefined_call_data_bucket_id = module.s3.ccc_unrefined_call_data_bucket_id
  ccc_transcribe_lambda_arn  = module.lambda.ccc_transcribe_lambda_arn
  ccc_verified_clean_bucket_id  = module.s3.ccc_verified_clean_bucket_id
  ccc_cleaned_bucket_id               = module.s3.ccc_cleaned_bucket_id
}

module "dynamodb" {
  source                 = "./modules/dynamodb"
  autoscaler_iam_role_id = module.iam.autoscaler_iam_role_id
  region                 = var.region
  environment            = var.environment
  application_use        = var.application_use
  namespace              = var.namespace
  company_code           = var.company_code
  application_code       = var.application_code
  environment_code       = var.environment_code
  region_code            = var.region_code
  owner                  = var.owner
  tag-version            = var.tag-version
  billing-guid           = var.billing-guid
  unit                   = var.unit
  portfolio              = var.portfolio
  support-group          = var.support-group
  cmdb-ci-id             = var.cmdb-ci-id
  data-classification    = var.data-classification
}

module "glue" {
  source                  = "./modules/glue"
  region                  = var.region
  environment             = var.environment
  application_use         = var.application_use
  namespace               = var.namespace
  company_code            = var.company_code
  application_code        = var.application_code
  environment_code        = var.environment_code
  region_code             = var.region_code
  owner                   = var.owner
  tag-version             = var.tag-version
  billing-guid            = var.billing-guid
  unit                    = var.unit
  portfolio               = var.portfolio
  support-group           = var.support-group
  cmdb-ci-id              = var.cmdb-ci-id
  data-classification     = var.data-classification
  athena_crawler_role_id  = module.iam.athena_crawler_role_id
  athena_crawler_role_arn = module.iam.athena_crawler_role_arn
  ccc_athenaresults_bucket_id  = module.s3.ccc_athenaresults_bucket_id
}

module "iam" {
  source                             = "./modules/iam"
  region                             = var.region
  environment                        = var.environment
  application_use                    = var.application_use
  company_code                       = var.company_code
  application_code                   = var.application_code
  environment_code                   = var.environment_code
  owner                              = var.owner
  namespace                          = var.namespace
  region_code                        = var.region_code
  tag-version                        = var.tag-version
  billing-guid                       = var.billing-guid
  unit                               = var.unit
  portfolio                          = var.portfolio
  support-group                      = var.support-group
  cmdb-ci-id                         = var.cmdb-ci-id
  data-classification                = var.data-classification
  account_id                         = local.account_id
  ccc_unrefined_call_data_bucket_arn = module.s3.ccc_unrefined_call_data_bucket_arn
  ccc_athenaresults_bucket_arn       = module.s3.ccc_athenaresults_bucket_arn
}

module "kms" {
  source                              = "./modules/kms"
  region                              = var.region
  environment                         = var.environment
  application_use                     = var.application_use
  company_code                        = var.company_code
  application_code                    = var.application_code
  environment_code                    = var.environment_code
  owner                               = var.owner
  namespace                           = var.namespace
  region_code                         = var.region_code
  tag-version                         = var.tag-version
  billing-guid                        = var.billing-guid
  unit                                = var.unit
  portfolio                           = var.portfolio
  support-group                       = var.support-group
  cmdb-ci-id                          = var.cmdb-ci-id
  data-classification                 = var.data-classification
  transcribe_lambda_role_arn          = module.iam.transcribe_lambda_role_arn
  comprehend_lambda_role_arn          = module.iam.comprehend_lambda_role_arn
  informational_macie_lambda_role_arn = module.iam.informational_macie_lambda_role_arn
  macie_lambda_role_arn               = module.iam.macie_lambda_role_arn
  trigger_macie_lambda_role_arn       = module.iam.trigger_macie_lambda_role_arn
  nla_replication_role_arn            = module.iam.nla_replication_role_arn
  account_id_insights                 = local.account_id_insights
}

module "lambda" {
  source                              = "./modules/lambda"
  tf_artifact_s3                      = var.tf_artifact_s3
  region                              = var.region
  environment                         = var.environment
  application_use                     = var.application_use
  company_code                        = var.company_code
  application_code                    = var.application_code
  environment_code                    = var.environment_code
  owner                               = var.owner
  namespace                           = var.namespace
  region_code                         = var.region_code
  tag-version                         = var.tag-version
  billing-guid                        = var.billing-guid
  unit                                = var.unit
  portfolio                           = var.portfolio
  support-group                       = var.support-group
  cmdb-ci-id                          = var.cmdb-ci-id
  data-classification                 = var.data-classification
  custom_transcribe_lambda_role_arn   = module.iam.custom_transcribe_lambda_role_arn
  transcribe_lambda_role_arn          = module.iam.transcribe_lambda_role_arn
  comprehend_lambda_role_arn          = module.iam.comprehend_lambda_role_arn
  informational_macie_lambda_role_arn = module.iam.informational_macie_lambda_role_arn
  macie_lambda_role_arn               = module.iam.macie_lambda_role_arn
  trigger_macie_lambda_role_arn       = module.iam.trigger_macie_lambda_role_arn
  sns_lambda_role_arn                 = module.iam.sns_lambda_role_arn
  audit_call_lambda_role_arn          = module.iam.audit_call_lambda_role_arn
  ccc_unrefined_call_data_bucket_arn  = module.s3.ccc_unrefined_call_data_bucket_arn
  ccc_verified_clean_bucket_arn       = module.s3.ccc_verified_clean_bucket_arn
  ccc_maciefindings_bucket_arn        = module.s3.ccc_maciefindings_bucket_arn
  ccc_cleaned_bucket_arn              = module.s3.ccc_cleaned_bucket_arn
  ccc_initial_bucket_arn              = module.s3.ccc_initial_bucket_arn
  ccc_initial_bucket_id               = module.s3.ccc_initial_bucket_id
  ccc_unrefined_call_data_bucket_id   = module.s3.ccc_unrefined_call_data_bucket_id
  ccc_cleaned_bucket_id               = module.s3.ccc_cleaned_bucket_id
  ccc_verified_clean_bucket_id        = module.s3.ccc_verified_clean_bucket_id
  ccc_dirty_bucket_id                 = module.s3.ccc_dirty_bucket_id
  ccc_athenaresults_bucket_id         = module.s3.ccc_athenaresults_bucket_id
  kms_key_ccc_sns_lambda_arn          = module.kms.kms_key_ccc_sns_lambda_arn
  dynamodb_audit_table_name           = module.dynamodb.dynamodb_audit_table_name
  customercallcenterpiitranscription_s3_event_rule_arn  = module.eventbridge.customercallcenterpiitranscription_s3_event_rule_arn
  customercallcenterpiicleanedverified_s3_event_rule_arn = module.eventbridge.customercallcenterpiicleanedverified_s3_event_rule_arn
  customercallcenterpiiunrefined_s3_event_rule_arn      = module.eventbridge.customercallcenterpiiunrefined_s3_event_rule_arn
  customercallcenterpiicleaned_s3_event_rule_arn        = module.eventbridge.customercallcenterpiicleaned_s3_event_rule_arn
}

module "s3" {
  source              = "./modules/s3"
  region              = var.region
  environment         = var.environment
  application_use     = var.application_use
  company_code        = var.company_code
  application_code    = var.application_code
  environment_code    = var.environment_code
  owner               = var.owner
  namespace           = var.namespace
  region_code         = var.region_code
  tag-version         = var.tag-version
  billing-guid        = var.billing-guid
  unit                = var.unit
  portfolio           = var.portfolio
  support-group       = var.support-group
  cmdb-ci-id          = var.cmdb-ci-id
  data-classification = var.data-classification
  # aws_assume_role                = var.aws_assume_role
  kms_key_ccc_unrefined_arn      = module.kms.kms_key_ccc_unrefined_arn
  kms_key_ccc_initial_arn        = module.kms.kms_key_ccc_initial_arn
  kms_key_ccc_clean_arn          = module.kms.kms_key_ccc_clean_arn
  kms_key_ccc_dirty_arn          = module.kms.kms_key_ccc_dirty_arn
  kms_key_ccc_verified_clean_arn = module.kms.kms_key_ccc_verified_clean_arn
  kms_key_ccc_maciefindings_arn  = module.kms.kms_key_ccc_maciefindings_arn
  kms_key_ccc_piimetadata_arn    = module.kms.kms_key_ccc_piimetadata_arn
  kms_key_ccc_athenaresults_arn  = module.kms.kms_key_ccc_athenaresults_arn
  macie_info_trigger_arn         = module.lambda.macie_info_trigger_arn
  # nla_replication_role_arn       = module.iam.nla_replication_role_arn
  account_id = local.account_id
}
