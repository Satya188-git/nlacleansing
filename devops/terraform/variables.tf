
variable "environment" {
  type        = string
  default     = "dev"
  description = "This value should be set as variable environment"
}
variable "region" {
  default     = "us-west-2"
  type        = string
  description = "The AWS region where to deploy Terraform resources"
}

variable "application_use" {
  default     = "nla"
  type        = string
  description = "The application use for Terraform resources"
}

variable "namespace" {
  default     = "internal.aws"
  type        = string
  description = "The AWS namespace to deploy Terraform resources"
}

variable "company_code" {
  default     = "sdge"
  type        = string
  description = "The company code prefix for Terraform resources"
}

variable "application_code" {
  default     = "dtdes"
  type        = string
  description = "The application code prefix for Terraform resources"
}

variable "environment_code" {
  default     = "dev"
  type        = string
  description = "The environment code prefix for Terraform resources"
}

variable "region_code" {
  default     = "wus2"
  type        = string
  description = "The AWS region short code prefix where to deploy Terraform resources"
}

variable "owner" {
  default     = "IAC Team"
  type        = string
  description = "The AWS Terraform resources owner"
}

variable "tag-version" {
  default     = "1"
  type        = string
  description = "Holds the version of the tagging format."
}

variable "billing-guid" {
  default     = "3993843B8B8C58852AEA9A4420D3E0CC"
  type        = string
  description = "Internal order - from SAP"
}

variable "unit" {
  default     = "Organizational unit"
  type        = string
  description = "Organizational unit"
}

variable "portfolio" {
  default     = "Portfolio associated with the application"
  type        = string
  description = "Portfolio associated with the application"
}

variable "support-group" {
  default     = "agile-iac@sdge.com"
  type        = string
  description = "Distribution list in email format"
}

variable "cmdb-ci-id" {
  default     = "CI ID as generated by ServiceNow CMDB"
  type        = string
  description = "CI ID as generated by ServiceNow CMDB"
}

variable "data-classification" {
  default     = "confidential"
  type        = string
  description = "Data privacy classification"
}
