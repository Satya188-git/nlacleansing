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

variable "account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "ccc_unrefined_call_data_bucket_arn" {
  type = string
}

variable "ccc_athenaresults_bucket_arn" {
  type        = string
  description = "The ccc_athenaresults S3 bucket ARN"
}
variable "aws_assume_role_user_pii" {
  type        = string
  description = "aws_assume_role_user_pii"
}

variable "ccc_piimetadata_bucket_arn" {
  type        = string
  description = "ccc_piimetadata_bucket_arn"
}

# variable "aws_assume_role_insights" {
#   type        = string
#   description = "aws_assume_role_insights"
# }
