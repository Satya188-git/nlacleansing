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

variable "kms_key_ccc_unrefined_arn" {
  type = string
}

variable "kms_key_ccc_initial_arn" {
  type = string
}

variable "kms_key_ccc_clean_arn" {
  type = string
}

variable "kms_key_ccc_dirty_arn" {
  type = string
}

variable "kms_key_ccc_verified_clean_arn" {
  type = string
}

variable "kms_key_ccc_maciefindings_arn" {
  type = string
}

variable "kms_key_ccc_piimetadata_arn" {
  type = string
}

variable "kms_key_ccc_athenaresults_arn" {
  type = string
}

variable "account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "macie_info_trigger_arn" {
  type        = string
  description = "macie_info_trigger_arn"
}

variable "nla_replication_role_arn" {
  type = string
}

variable "s3bucket_insights_replication_arn" {
  type        = string
  description = "Name of s3 bucket on insights account for object replication"
}

variable "insights_account_id" {
  type        = string
  description = "AWS account id for NLA Insights accounts"
}

variable "insights_s3kms_arn" {
  type        = string
  description = "NLA Insights account KMS key to encrypt replicated S3 objects"
}
