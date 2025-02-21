provider "aws" {
  region = var.region
  # assume_role {
  #   role_arn     = var.aws_assume_role_pii
  #   session_name = "AWS-STSSession-PII"
  # }
  default_tags {
    tags = {
      "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
      billing-guid        = var.billing-guid
      "sempra:gov:unit"   = var.unit 				# unit                = var.unit
      portfolio           = var.portfolio
      support-group       = var.support-group
      "sempra:gov:environment" = var.environment 	# environment         = var.environment
      "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
      data-classification = var.data-classification
    }
  }  
}
