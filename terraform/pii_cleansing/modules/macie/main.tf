locals {
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  # tags = {
  #   "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
	# "sempra:gov:unit"   = var.unit 				# unit                = var.unit
  #   billing-guid        = var.billing-guid
  #   portfolio           = var.portfolio
  #   support-group       = var.support-group
  #   "sempra:gov:environment" = var.environment 	# environment         = var.environment
  #   "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
  #   data-classification = var.data-classification
  # }
}

resource "aws_macie2_account" "nla_macie" {
  status                       = "ENABLED"
}

resource "aws_macie2_classification_export_configuration" "macie_s3_bucket" {
  depends_on = [aws_macie2_account.nla_macie, var.ccc_maciefindings_bucket_id, var.kms_key_ccc_maciefindings_arn]
  s3_destination {
    bucket_name = var.ccc_maciefindings_bucket_id
    kms_key_arn = var.kms_key_ccc_maciefindings_arn
  }
}

resource "aws_macie2_custom_data_identifier" "nla_macie_identifier1" {
  depends_on             = [aws_macie2_account.nla_macie]
  name                   = "CCC-Digits"
  regex                  = "\\d{3,}"
  description            = "This will capture numbers longer than 2 digits (includes account numbers)"
  maximum_match_distance = 50
  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-macie-identifier1"
    },
  )
}

resource "aws_macie2_custom_data_identifier" "nla_macie_identifier2" {
  depends_on             = [aws_macie2_account.nla_macie]
  name                   = "CCC-Spellings"
  regex                  = "([A-Z]{1}\\.?\\s){3,}"
  description            = "This will capture when client have spelled some names"
  maximum_match_distance = 50
  tags = merge(data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-macie-identifier2"
    },
  )
}