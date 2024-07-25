provider "aws" {
  region = var.region
  # assume_role {
  #   role_arn     = var.aws_assume_role_pii
  #   session_name = "AWS-STSSession-PII"
  # }
  default_tags {
    tags = {
      "sempra:gov:environment" = var.environment
      "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id
    }
  }  
}
