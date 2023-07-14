
variable "ccc_initial_bucket_id" {
  type        = string
  description = "S3 ccc_initial_bucket_id"
}

variable "comprehend_lambda_arn" {
  type        = string
  description = "comprehend_lambda_arn"
}

variable "environment" {
  type        = string
  description = "The AWS environment where to deploy Terraform resources"
}

variable "region" {
  type        = string
  description = "The AWS region where to deploy Terraform resources"
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

variable "unit" {
  type        = string
  description = "Organizational unit"
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

variable "ccc_audit_call_lambda_arn" {
  type        = string
  description = "ccc_audit_call_lambda_arn"
}

variable "ccc_unrefined_call_data_bucket_id" {
  type        = string
  description = "ccc_unrefined_call_data_bucket_id"
}

variable "ccc_transcribe_lambda_arn" {
  type        = string
  description = "ccc_transcribe_lambda_arn"
}

variable "ccc_verified_clean_bucket_id" {
  type        = string
  description = "ccc_verified_clean_bucket_id"
}

variable "ccc_cleaned_bucket_id" {
  type        = string
  description = "ccc_cleaned_bucket_id"
}

variable "ccc_maciefindings_bucket_id" {
  type        = string
  description = "ccc_maciefindings_bucket_id"
}

variable "macie_info_trigger_arn" {
  type        = string
  description = "macie_info_trigger_arn"
}

variable "macie_scan_trigger_arn" {
  type        = string
  description = "macie_scan_trigger_arn"
}

variable "ccc_audio_copy_lambda_arn" {
  type        = string
  description = "ccc_audio_copy_lambda_arn"
}

variable "ccc_callrecordings_bucket_id" {
  type        = string
  description = "ccc_callrecordings_bucket_id"
}

variable "ccc_piimetadata_bucket_id" {
  type        = string
  description = "ccc_piimetadata_bucket_id"
}

variable "ccc_insights_audio_bucket_id" {
  type        = string
  description = "ccc_insights_audio_bucket_id"
}

variable "ccc_callaudioaccesslogs_bucket_id" {
  type        = string
  description = "ccc_callaudioaccesslogs_bucket_id"
}

variable "ccc_audio_access_logs_to_cw_lambda_arn" {
  type        = string
  description = "ccc_audio_access_logs_to_cw_lambda_arn"
}


