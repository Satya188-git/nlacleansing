variable "region" {
  type        = string
  description = "The AWS region where to deploy Terraform resources"
}
variable "environment" {
  type = string
}
variable "application_use" {
  type        = string
  description = "The application use for Terraform resources"
}

variable "namespace" {
  type        = string
  description = "The AWS namespace to deploy Terraform resources"
}

variable "company_code" {
  type        = string
  description = "The company code prefix for Terraform resources"
}

variable "unit" {
  type        = string
  description = "Organizational unit"
}

variable "application_code" {
  type        = string
  description = "The application code prefix for Terraform resources"
}

variable "environment_code" {
  type        = string
  description = "The environment code prefix for Terraform resources"
}

variable "region_code" {
  type        = string
  description = "The AWS region short code prefix where to deploy Terraform resources"
}

variable "owner" {
  type        = string
  description = "The AWS Terraform resources owner"
}

variable "tag-version" {
  type        = string
  description = "Holds the version of the tagging format."
}

variable "billing-guid" {
  type        = string
  description = "Internal order - from SAP"
}

variable "portfolio" {
  type        = string
  description = "Portfolio associated with the application"
}

variable "support-group" {
  type        = string
  description = "Distribution list in email format"
}

variable "cmdb-ci-id" {
  type        = string
  description = "CI ID as generated by ServiceNow CMDB"
}

variable "data-classification" {
  type        = string
  description = "Data privacy classification"
}

variable "account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "custom_transcribe_lambda_role_arn" {
  type = string
}

variable "transcribe_lambda_role_arn" {
  type = string
}

variable "comprehend_lambda_role_arn" {
  type = string
}

variable "informational_macie_lambda_role_arn" {
  type = string
}

variable "trigger_macie_lambda_role_arn" {
  type = string
}

variable "sns_lambda_role_arn" {
  type = string
}

variable "audit_call_lambda_role_arn" {
  type = string
}

variable "ccc_unrefined_call_data_bucket_arn" {
  type = string
}

variable "ccc_verified_clean_bucket_arn" {
  type = string
}

variable "ccc_maciefindings_bucket_arn" {
  type = string
}

variable "ccc_cleaned_bucket_arn" {
  type = string
}

variable "ccc_initial_bucket_arn" {
  type = string
}

variable "ccc_initial_bucket_id" {
  type        = string
  description = "ccc_initial_bucket_id"
}

variable "ccc_unrefined_call_data_bucket_id" {
  type        = string
  description = "ccc_unrefined_call_data_bucket_id"
}

variable "ccc_cleaned_bucket_id" {
  type        = string
  description = "ccc_cleaned_bucket_id"
}

variable "ccc_verified_clean_bucket_id" {
  type        = string
  description = "ccc_verified_clean_bucket_id"
}

variable "ccc_dirty_bucket_id" {
  type        = string
  description = "ccc_dirty_bucket_id"
}

variable "ccc_athenaresults_bucket_id" {
  type        = string
  description = "ccc_athenaresults_bucket_id"
}

variable "nla_glue_table_name" {
  type        = string
  description = "nla_glue_table_name"
}

variable "dynamodb_audit_table_name" {
  type        = string
  description = "dynamodb_audit_table_name"
}

variable "tf_artifact_s3" {
  type = string
}

variable "kms_key_ccc_sns_lambda_arn" {
  type        = string
  description = "kms_key_ccc_sns_lambda_arn"
}

variable "ccc_athenaresults_bucket_arn" {
  type        = string
  description = "ccc_athenaresults_bucket_arn"
}

variable "customercallcenterpiitranscription_s3_event_rule_arn" {
  type        = string
  description = "customercallcenterpiitranscription_s3_event_rule_arn"
}

variable "customercallcenterpiiunrefined_s3_event_rule_arn" {
  type        = string
  description = "customercallcenterpiiunrefined_s3_event_rule_arn"
}

variable "customercallcenterpiicleanedverified_s3_event_rule_arn" {
  type        = string
  description = "customercallcenterpiicleanedverified_s3_event_rule_arn"
}

variable "customercallcenterpiicleaned_s3_event_rule_arn" {
  type        = string
  description = "customercallcenterpiicleaned_s3_event_rule_arn"
}

variable "customercallcenterpiimaciescan_s3_event_rule_arn" {
  type        = string
  description = "customercallcenterpiimaciescan_s3_event_rule_arn"
}

variable "customercallcenterpiimacieinfo_s3_event_rule_arn" {
  type        = string
  description = "customercallcenterpiimacieinfo_s3_event_rule_arn"
}

variable "athena_database_name" {
  type        = string
  description = "athena_database_name"
}