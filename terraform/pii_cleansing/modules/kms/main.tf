locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  application_name = "nla-key"
  description      = "KMS for encrypting AWS resources"
  tags = {
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    unit                = var.unit
    data-classification = var.data-classification
  }
}

module "athena_kms_key" {
  source           = "app.terraform.io/SempraUtilities/seu-kms/aws"
  version          = "4.0.2"
  description      = local.description
  aws_region       = local.region
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_name = local.application_name
  tags = merge(local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-kms-nla-athena-key"
    },
  )
}

# provider "aws" {
#   alias  = "nla-insights"
#   region = var.region
#   assume_role {
#     role_arn     = var.aws_assume_role_insights
#     session_name = "AWS-STSSession-Insights"
#   }
# }


# module "ccc_verified_clean_insights_kms_key" {
#   providers        = { aws = aws.nla-insights }
#   source           = "app.terraform.io/SempraUtilities/seu-kms/aws"
#   version          = "4.0.2"
#   description      = local.description
#   aws_region       = local.region
#   company_code     = local.company_code
#   application_code = local.application_code
#   environment_code = local.environment_code
#   region_code      = local.region_code
#   application_name = local.application_name

#   tags = merge(local.tags,
#     {
#       name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-verified-clean-insights-key"
#     },
#   )

#   policy = <<EOT
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "${var.nla_replication_role_arn}"
#             },
#             "Action": [
#                 "kms:Encrypt",
#                 "kms:ReEncrypt*",
#                 "kms:GenerateDataKey*",
#                 "kms:DescribeKey"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::${var.account_id_insights}:root"
#             },
#             "Action": "kms:*",
#             "Resource": "*"
#         },
#         {
#             "Sid": "AllowLambdaDecrypt",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::713342716921:role/call-list-lambda-role-NLA-temp" (Insights call list lambda role)
#             },
#             "Action": "kms:Decrypt",
#             "Resource": "arn:aws:s3:::ccc-verified-cleaned-nla-temp/*"
#         }
#     ]
# }
# EOT
# }

resource "aws_kms_key" "unrefined_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "unrefined_kms_key" {
  name          = "alias/${local.application_use}-unrefined_kms_key"
  target_key_id = aws_kms_key.unrefined_kms_key.key_id
}

// create kms key to encrypt athena data
resource "aws_kms_key" "athena_kms_key" {
  deletion_window_in_days = 7
  description             = "Athena KMS Key"
  enable_key_rotation     = true
}

# ccc_initial_bucket
resource "aws_kms_key" "initial_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "initial_kms_key" {
  name          = "alias/${local.application_use}-initial_kms_key"
  target_key_id = aws_kms_key.initial_kms_key.key_id
}

resource "aws_kms_key" "clean_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "clean_kms_key" {
  name          = "alias/${local.application_use}-clean_kms_key"
  target_key_id = aws_kms_key.clean_kms_key.key_id
}

resource "aws_kms_key" "dirty_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "dirty_kms_key" {
  name          = "alias/${local.application_use}-dirty_kms_key"
  target_key_id = aws_kms_key.dirty_kms_key.key_id
}

resource "aws_kms_key" "verified_clean_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "verified_clean_kms_key" {
  name          = "alias/${local.application_use}-verified_clean_kms_key"
  target_key_id = aws_kms_key.verified_clean_kms_key.key_id
}

# maciefindings
resource "aws_kms_key" "maciefindings_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "maciefindings_kms_key" {
  name          = "alias/${local.application_use}-maciefindings_kms_key"
  target_key_id = aws_kms_key.maciefindings_kms_key.key_id
}

# piimetadata
resource "aws_kms_key" "piimetadata_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "piimetadata_kms_key" {
  name          = "alias/${local.application_use}-piimetadata_kms_key"
  target_key_id = aws_kms_key.piimetadata_kms_key.key_id
}

# athena
resource "aws_kms_key" "athenaresults_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "athenaresults_kms_key" {
  name          = "alias/${local.application_use}-athenaresults_kms_key"
  target_key_id = aws_kms_key.athenaresults_kms_key.key_id
}

resource "aws_kms_key" "sns_lambda_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "sns_lambda_kms_key" {
  name          = "alias/${local.application_use}-sns_lambda_kms_key"
  target_key_id = aws_kms_key.sns_lambda_kms_key.key_id
}


# grants
resource "aws_kms_grant" "transcribe_lambda_role_kms_key" {
  name              = "${local.application_use}-lambda_role_kms_key_1"
  key_id            = aws_kms_key.unrefined_kms_key.key_id
  grantee_principal = var.transcribe_lambda_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "comprehend_lambda_role_kms_key" {
  name              = "${local.application_use}-lambda_role_kms_key_2"
  key_id            = aws_kms_key.initial_kms_key.key_id
  grantee_principal = var.comprehend_lambda_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "infoMacie_lambda_role_kms_key" {
  name              = "${local.application_use}-lambda_role_kms_key_3"
  key_id            = aws_kms_key.clean_kms_key.key_id
  grantee_principal = var.informational_macie_lambda_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "ccc_notification_forwarder_lambda" {
  name              = "${local.application_use}-lambda_role_kms_key_5"
  key_id            = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.macie_lambda_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "ccc_macie_scan_trigger_lambda" {
  name              = "${local.application_use}-lambda_role_kms_key_6"
  key_id            = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.trigger_macie_lambda_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}
