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
  glue_table_name  = "${local.company_code}_${local.application_code}_${local.environment_code}_${local.region_code}_glue_nla_s3_crawler_pii_metadata"
  tags = {
    "sempra:gov:tag-version" = var.tag-version # tag-version         = var.tag-version
    billing-guid             = var.billing-guid
    "sempra:gov:unit"        = var.unit # unit                = var.unit
    portfolio                = var.portfolio
    support-group            = var.support-group
    "sempra:gov:environment" = var.environment # environment         = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id  # cmdb-ci-id          = var.cmdb-ci-id
    data-classification      = var.data-classification
  }
}

data "aws_caller_identity" "current" {}

module "athena" {
  source                       = "./modules/athena"
  region                       = var.region
  environment                  = var.environment
  application_use              = var.application_use
  namespace                    = var.namespace
  company_code                 = var.company_code
  application_code             = var.application_code
  environment_code             = var.environment_code
  region_code                  = var.region_code
  owner                        = var.owner
  tag-version                  = var.tag-version
  billing-guid                 = var.billing-guid
  unit                         = var.unit
  portfolio                    = var.portfolio
  support-group                = var.support-group
  cmdb-ci-id                   = var.cmdb-ci-id
  data-classification          = var.data-classification
  ccc_athenaresults_bucket_id  = module.s3.ccc_athenaresults_bucket_id
  ccc_athenaresults_bucket_arn = module.s3.ccc_athenaresults_bucket_arn
  athena_kms_key_arn           = module.kms.athena_kms_key_arn
}

module "eventbridge" {
  source                                                  = "./modules/eventbridge"
  region                                                  = var.region
  environment                                             = var.environment
  application_use                                         = var.application_use
  company_code                                            = var.company_code
  application_code                                        = var.application_code
  environment_code                                        = var.environment_code
  owner                                                   = var.owner
  namespace                                               = var.namespace
  region_code                                             = var.region_code
  tag-version                                             = var.tag-version
  billing-guid                                            = var.billing-guid
  unit                                                    = var.unit
  portfolio                                               = var.portfolio
  support-group                                           = var.support-group
  cmdb-ci-id                                              = var.cmdb-ci-id
  data-classification                                     = var.data-classification
  comprehend_lambda_arn                                   = module.lambda.comprehend_lambda_arn
  ccc_initial_bucket_id                                   = module.s3.ccc_initial_bucket_id
  ccc_audit_call_lambda_arn                               = module.lambda.ccc_audit_call_lambda_arn
  ccc_unrefined_call_data_bucket_id                       = module.s3.ccc_unrefined_call_data_bucket_id
  ccc_transcribe_lambda_arn                               = module.lambda.ccc_transcribe_lambda_arn
  ccc_verified_clean_bucket_id                            = module.s3.ccc_verified_clean_bucket_id
  ccc_cleaned_bucket_id                                   = module.s3.ccc_cleaned_bucket_id
  ccc_maciefindings_bucket_id                             = module.s3.ccc_maciefindings_bucket_id
  macie_scan_trigger_arn                                  = module.lambda.macie_scan_trigger_arn
  macie_info_trigger_arn                                  = module.lambda.macie_info_trigger_arn
  ccc_audio_copy_lambda_arn                               = module.lambda.ccc_audio_copy_lambda_arn
  ccc_callrecordings_bucket_id                            = module.s3.ccc_callrecordings_bucket_id
  ccc_piimetadata_bucket_id                               = module.s3.ccc_piimetadata_bucket_id
  ccc_insights_audio_bucket_id                            = module.s3.ccc_insights_audio_bucket_id
  ccc_audio_access_logs_to_cw_lambda_arn                  = module.lambda.ccc_audio_access_logs_to_cw_lambda_arn
  ccc_callaudioaccesslogs_bucket_id                       = module.s3.ccc_callaudioaccesslogs_bucket_id
  sns-supervisor-data-notification-topic-subscription-arn = one(module.sns.sns-supervisor-data-notification-topic-subscription-arn)
  ccc_nla_access_logs_bucket_id                           = module.s3.ccc_nla_access_logs_bucket_id
  ccc_access_denied_notification_lambda_arn               = module.lambda.ccc_access_denied_notification_lambda_arn
  key_rotation_alert_lambda_arn                           = module.lambda.key_rotation_alert_lambda_arn
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
  source                         = "./modules/glue"
  region                         = var.region
  environment                    = var.environment
  application_use                = var.application_use
  namespace                      = var.namespace
  company_code                   = var.company_code
  application_code               = var.application_code
  environment_code               = var.environment_code
  region_code                    = var.region_code
  owner                          = var.owner
  tag-version                    = var.tag-version
  billing-guid                   = var.billing-guid
  unit                           = var.unit
  portfolio                      = var.portfolio
  support-group                  = var.support-group
  cmdb-ci-id                     = var.cmdb-ci-id
  data-classification            = var.data-classification
  athena_crawler_role_id         = module.iam.athena_crawler_role_id
  athena_crawler_role_arn        = module.iam.athena_crawler_role_arn
  ccc_athenaresults_bucket_id    = module.s3.ccc_athenaresults_bucket_id
  ccc_piimetadata_bucket_id      = module.s3.ccc_piimetadata_bucket_id
  athena_database_name           = module.athena.athena_database_name
  ccc_historical_calls_bucket_id = module.s3.ccc_historical_calls_bucket_id
}

module "iam" {
  source                               = "./modules/iam"
  region                               = var.region
  environment                          = var.environment
  application_use                      = var.application_use
  company_code                         = var.company_code
  application_code                     = var.application_code
  environment_code                     = var.environment_code
  owner                                = var.owner
  namespace                            = var.namespace
  region_code                          = var.region_code
  tag-version                          = var.tag-version
  billing-guid                         = var.billing-guid
  unit                                 = var.unit
  portfolio                            = var.portfolio
  support-group                        = var.support-group
  cmdb-ci-id                           = var.cmdb-ci-id
  data-classification                  = var.data-classification
  account_id                           = local.account_id
  kms_key_ccc_verified_clean_arn       = module.kms.kms_key_ccc_verified_clean_arn
  kms_key_ccc_piimetadata_arn          = module.kms.kms_key_ccc_piimetadata_arn
  ccc_verified_clean_bucket_arn        = module.s3.ccc_verified_clean_bucket_arn
  ccc_unrefined_call_data_bucket_arn   = module.s3.ccc_unrefined_call_data_bucket_arn
  ccc_athenaresults_bucket_arn         = module.s3.ccc_athenaresults_bucket_arn
  ccc_piimetadata_bucket_arn           = module.s3.ccc_piimetadata_bucket_arn
  insights_account_id                  = var.insights_account_id
  s3bucket_insights_replication_arn    = var.s3bucket_insights_replication_arn
  kms_key_ccc_unrefined_arn            = module.kms.kms_key_ccc_unrefined_arn
  ccc_insights_audio_bucket_arn        = module.s3.ccc_insights_audio_bucket_arn
  ccc_callrecordings_bucket_arn        = module.s3.ccc_callrecordings_bucket_arn
  audit_lambda_arn                     = module.lambda.ccc_audit_call_lambda_arn
  access_denied_notification_topic_arn = one(module.sns.access_denied_notification_topic_arn)
  ccc_historical_calls_bucket_arn      = module.s3.ccc_historical_calls_bucket_arn
  key_rotation_sns_arn                 = one(module.sns.key_rotation_sns_arn)
  sns_kms_key_arn                      = module.kms.sns_kms_key_arn
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
  account_id                          = local.account_id
  insights_account_id                 = var.insights_account_id
  transcribe_lambda_role_arn          = module.iam.transcribe_lambda_role_arn
  comprehend_lambda_role_arn          = module.iam.comprehend_lambda_role_arn
  informational_macie_lambda_role_arn = module.iam.informational_macie_lambda_role_arn
  trigger_macie_lambda_role_arn       = module.iam.trigger_macie_lambda_role_arn
  nla_replication_role_arn            = module.iam.nla_replication_role_arn
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
  account_id                          = local.account_id
  custom_transcribe_lambda_role_arn   = module.iam.custom_transcribe_lambda_role_arn
  transcribe_lambda_role_arn          = module.iam.transcribe_lambda_role_arn
  comprehend_lambda_role_arn          = module.iam.comprehend_lambda_role_arn
  informational_macie_lambda_role_arn = module.iam.informational_macie_lambda_role_arn
  trigger_macie_lambda_role_arn       = module.iam.trigger_macie_lambda_role_arn
  sns_lambda_role_arn                 = module.iam.sns_lambda_role_arn
  audit_call_lambda_role_arn          = module.iam.audit_call_lambda_role_arn
  audio_copy_lambda_role_arn          = module.iam.audio_copy_lambda_role_arn
  ccc_athenaresults_bucket_arn        = module.s3.ccc_athenaresults_bucket_arn
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
  ccc_callrecordings_bucket_id        = module.s3.ccc_callrecordings_bucket_id
  kms_key_ccc_sns_lambda_arn          = module.kms.kms_key_ccc_sns_lambda_arn
  #dynamodb_audit_table_name                             = module.dynamodb.dynamodb_audit_table_name
  dynamodb_nla_audit_table_name                          = module.dynamodb.dynamodb_nla_audit_table_name
  customercallcenterpiitranscription_s3_event_rule_arn   = module.eventbridge.customercallcenterpiitranscription_s3_event_rule_arn
  customercallcenterpiicleanedverified_s3_event_rule_arn = module.eventbridge.customercallcenterpiicleanedverified_s3_event_rule_arn
  customercallcenterpiiunrefined_s3_event_rule_arn       = module.eventbridge.customercallcenterpiiunrefined_s3_event_rule_arn
  customercallcenterpiicleaned_s3_event_rule_arn         = module.eventbridge.customercallcenterpiicleaned_s3_event_rule_arn
  #customercallcenterpiimaciescan_s3_event_rule_arn      = module.eventbridge.customercallcenterpiimaciescan_s3_event_rule_arn
  customercallcenterpiimaciescanscheduler_s3_event_rule_arn = module.eventbridge.customercallcenterpiimaciescanscheduler_s3_event_rule_arn
  customercallcenterpiimacieinfo_s3_event_rule_arn          = module.eventbridge.customercallcenterpiimacieinfo_s3_event_rule_arn
  ccc_audio_copy_s3_event_rule_arn                          = module.eventbridge.ccc_audio_copy_s3_event_rule_arn
  callrecordings_audio_s3_event_rule_arn                    = module.eventbridge.callrecordings_audio_s3_event_rule_arn
  callrecordings_metadata_s3_event_rule_arn                 = module.eventbridge.callrecordings_metadata_s3_event_rule_arn
  pii_metadata_s3_event_rule_arn                            = module.eventbridge.pii_metadata_s3_event_rule_arn
  audio_s3_event_rule_arn                                   = module.eventbridge.audio_s3_event_rule_arn
  key_rotation_alert_lambda_scheduler_rule_arn              = module.eventbridge.key_rotation_alert_lambda_scheduler_rule_arn
  athena_database_name                                      = module.athena.athena_database_name
  nla_glue_table_name                                       = module.glue.nla_glue_table_name[local.glue_table_name]
  nla_glue_database_name                                    = module.glue.nla_glue_database_name
  ccc_insights_audio_bucket_id                              = module.s3.ccc_insights_audio_bucket_id
  ccc_piimetadata_bucket_id                                 = module.s3.ccc_piimetadata_bucket_id
  callaudioaccess_log_group_name                            = module.cloudwatch.callaudioaccess_log_group_name
  ccc_audio_access_logs_to_cw_lambda_role_arn               = module.iam.ccc_audio_access_logs_to_cw_lambda_role_arn
  ccc_audio_access_logs_s3_event_rule_arn                   = module.eventbridge.ccc_audio_access_logs_s3_event_rule_arn
  ccc_access_denied_notification_lambda_role_arn            = module.iam.ccc_access_denied_notification_lambda_role_arn
  ccc_access_denied_notification_logs_s3_event_rule_arn     = module.eventbridge.ccc_access_denied_notification_logs_s3_event_rule_arn
  key_rotation_alert_lambda_role_arn                        = module.iam.key_rotation_alert_lambda_role_arn
  access_denied_notification_topic_arn                      = one(module.sns.access_denied_notification_topic_arn)
  file_transfer_lambda_role_arn                             = module.iam.file_transfer_lambda_role_arn
  key_rotation_sns_arn                                      = one(module.sns.key_rotation_sns_arn)
}

module "macie" {
  source                        = "./modules/macie"
  environment                   = var.environment
  tag-version                   = var.tag-version
  billing-guid                  = var.billing-guid
  portfolio                     = var.portfolio
  support-group                 = var.support-group
  cmdb-ci-id                    = var.cmdb-ci-id
  data-classification           = var.data-classification
  ccc_maciefindings_bucket_id   = module.s3.ccc_maciefindings_bucket_id
  kms_key_ccc_maciefindings_arn = module.kms.kms_key_ccc_maciefindings_arn
  unit                          = var.unit
  company_code                  = var.company_code
  application_code              = var.application_code
  environment_code              = var.environment_code
  region_code                   = var.region_code
}

module "s3" {
  source                                = "./modules/s3"
  region                                = var.region
  environment                           = var.environment
  application_use                       = var.application_use
  company_code                          = var.company_code
  application_code                      = var.application_code
  environment_code                      = var.environment_code
  owner                                 = var.owner
  namespace                             = var.namespace
  region_code                           = var.region_code
  tag-version                           = var.tag-version
  billing-guid                          = var.billing-guid
  unit                                  = var.unit
  portfolio                             = var.portfolio
  support-group                         = var.support-group
  cmdb-ci-id                            = var.cmdb-ci-id
  data-classification                   = var.data-classification
  oidc_iam_role_name                    = var.oidc_iam_role_name
  nla_insights_historic_call_lambda_arn = var.nla_insights_historic_call_lambda_arn
  kms_key_ccc_unrefined_arn             = module.kms.kms_key_ccc_unrefined_arn
  kms_key_ccc_initial_arn               = module.kms.kms_key_ccc_initial_arn
  kms_key_ccc_clean_arn                 = module.kms.kms_key_ccc_clean_arn
  kms_key_ccc_dirty_arn                 = module.kms.kms_key_ccc_dirty_arn
  kms_key_ccc_verified_clean_arn        = module.kms.kms_key_ccc_verified_clean_arn
  kms_key_ccc_maciefindings_arn         = module.kms.kms_key_ccc_maciefindings_arn
  kms_key_ccc_piimetadata_arn           = module.kms.kms_key_ccc_piimetadata_arn
  kms_key_ccc_athenaresults_arn         = module.kms.kms_key_ccc_athenaresults_arn
  macie_info_trigger_arn                = module.lambda.macie_info_trigger_arn
  nla_replication_role_arn              = module.iam.nla_replication_role_arn
  insights_assumed_role_arn             = module.iam.insights_assumed_role_arn
  audio_copy_lambda_role_arn            = module.iam.audio_copy_lambda_role_arn
  transcribe_lambda_role_arn            = module.iam.transcribe_lambda_role_arn
  custom_transcribe_lambda_role_arn     = module.iam.custom_transcribe_lambda_role_arn
  comprehend_lambda_role_arn            = module.iam.comprehend_lambda_role_arn
  trigger_macie_lambda_role_arn         = module.iam.trigger_macie_lambda_role_arn
  file_transfer_lambda_role_arn         = module.iam.file_transfer_lambda_role_arn
  s3bucket_insights_replication_arn     = var.s3bucket_insights_replication_arn
  account_id                            = local.account_id
  insights_account_id                   = var.insights_account_id
  insights_s3kms_arn                    = var.insights_s3kms_arn
  athena_access_role                    = var.athena_access_role
}


module "sns" {
  source                          = "./modules/sns"
  region                          = var.region
  environment                     = var.environment
  application_use                 = var.application_use
  company_code                    = var.company_code
  application_code                = var.application_code
  environment_code                = var.environment_code
  region_code                     = var.region_code
  tag-version                     = var.tag-version
  billing-guid                    = var.billing-guid
  portfolio                       = var.portfolio
  support-group                   = var.support-group
  cmdb-ci-id                      = var.cmdb-ci-id
  data-classification             = var.data-classification
  sns_kms_key_id                  = module.kms.sns_kms_key_id
  account_id                      = local.account_id
  audioaccessnotificationemail    = var.audioaccessnotificationemail
  supervisordatanotificationemail = var.supervisordatanotificationemail
  unit                            = var.unit
  nlaaudioaccessnotificationemail = var.nlaaudioaccessnotificationemail
  sns_email1                      = var.sns_email1
}

module "cloudwatch" {
  source              = "./modules/cloudwatch"
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
  sns-topic-arn       = one(module.sns.sns-topic-arn)
}

module "sqs"{
  source                            = "./modules/sqs"
  account_id                        = local.account_id
  region                            = var.region
  environment                       = var.environment
  application_use                   = var.application_use
  company_code                      = var.company_code
  application_code                  = var.application_code
  environment_code                  = var.environment_code
  owner                             = var.owner
  namespace                         = var.namespace
  region_code                       = var.region_code
  tag-version                       = var.tag-version
  billing-guid                      = var.billing-guid
  unit                              = var.unit
  portfolio                         = var.portfolio
  support-group                     = var.support-group
  cmdb-ci-id                        = var.cmdb-ci-id
  data-classification               = var.data-classification
  insights_account_id               = var.insights_account_id
  sqs_kms_key_id                   = module.kms.sqs_kms_key_id
}