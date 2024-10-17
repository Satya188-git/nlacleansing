variable "athena_crawler_role_id" {
  type        = string
  description = "The athena_crawler_role ID"
}

variable "athena_crawler_role_arn" {
  type        = string
  description = "The athena_crawler_role ARN"
}

variable "ccc_piimetadata_bucket_id" {
  type        = string
  description = "ccc_piimetadata_bucket_id"
}

variable "athena_database_name" {
  type        = string
  description = "athena_database_name"
}

variable "ccc_athenaresults_bucket_id" {
  type        = string
  description = "The ccc_athenaresults S3 bucket id (name)"
}

variable "crawler_description" {
  type        = string
  default     = "Glue Crawler for Athena S3 data"
  description = "Glue Crawler for Athena S3 data"
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

variable "ccc_historical_calls_bucket_id" {
  type        = string
  description = "ccc_historical_calls_bucket_id"
}