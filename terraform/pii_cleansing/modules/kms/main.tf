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
    "sempra:gov:tag-version" = var.tag-version
    billing-guid             = var.billing-guid
    portfolio                = var.portfolio
    support-group            = var.support-group
    "sempra:gov:environment" = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id
    "sempra:gov:unit"        = var.unit
    data-classification      = var.data-classification
  }
}

data "aws_iam_policy_document" "kms_default_policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey",
      "kms:kms:GenerateDataKeyWithoutPlaintext",
      "kms:DescribeKey",
      "kms:CreateGrant",
      "kms:PutKeyPolicy",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ListResourceTags",
      "kms:ListKeyPolicies",
      "kms:ListAliases",
      "kms:GetKeyPolicy",
      "kms:ListGrants",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:UpdateAlias",
      "kms:GetPublicKey",
      "kms:UpdateKeyDescription",
      "kms:EnableKeyRotation",
      "kms:DisableKeyRotation",
      "kms:UpdatePrimaryRegion",
      "kms:ReplicateKey",
      "kms:GetKeyRotationStatus"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root","arn:aws:iam::${var.account_id}:role/aws-service-role/macie.amazonaws.com/AWSServiceRoleForAmazonMacie"]
    }
  }
}

module "athena_kms_key" {
  source           = "app.terraform.io/SempraUtilities/seu-kms/aws"
  version          = "10.0.0"
  description      = local.description
  aws_region       = local.region
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${var.application_use}-athena-kms-key"
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-athena-kms-key"
    },
  )
}

resource "aws_kms_key" "unrefined_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-unrefined-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
}

resource "aws_kms_alias" "unrefined_kms_key" {
  name          = "alias/${local.application_use}-unrefined_kms_key"
  target_key_id = aws_kms_key.unrefined_kms_key.key_id
}

# ccc_initial_bucket
resource "aws_kms_key" "initial_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-initial-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
}

resource "aws_kms_alias" "initial_kms_key" {
  name          = "alias/${local.application_use}-initial_kms_key"
  target_key_id = aws_kms_key.initial_kms_key.key_id
}

resource "aws_kms_key" "clean_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-clean-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
}

resource "aws_kms_alias" "clean_kms_key" {
  name          = "alias/${local.application_use}-clean_kms_key"
  target_key_id = aws_kms_key.clean_kms_key.key_id
}

resource "aws_kms_key" "dirty_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-dirty-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
}

resource "aws_kms_alias" "dirty_kms_key" {
  name          = "alias/${local.application_use}-dirty_kms_key"
  target_key_id = aws_kms_key.dirty_kms_key.key_id
}

resource "aws_kms_key" "verified_clean_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-verified-clean-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
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
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-maciefindings-kms-key"
    },
  )

  policy = <<EOT
    {
    "Version": "2012-10-17",
    "Id": "S3-Key-Policy",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.account_id}:root"
            },
            "Action": [
              "kms:Encrypt",
              "kms:Decrypt", 
              "kms:ReEncrypt", 
              "kms:GenerateDataKey", 
              "kms:kms:GenerateDataKeyWithoutPlaintext",
              "kms:DescribeKey", 
              "kms:CreateGrant", 
              "kms:PutKeyPolicy", 
              "kms:TagResource", 
              "kms:UntagResource", 
              "kms:ListResourceTags", 
              "kms:ListKeyPolicies", 
              "kms:ListAliases", 
              "kms:GetKeyPolicy", 
              "kms:ListGrants",
              "kms:ReEncryptFrom",
              "kms:ReEncryptTo",
              "kms:CreateAlias",
              "kms:DeleteAlias",
              "kms:UpdateAlias",
              "kms:GetPublicKey",
              "kms:UpdateKeyDescription",
              "kms:EnableKeyRotation",
              "kms:DisableKeyRotation",
              "kms:UpdatePrimaryRegion",
              "kms:ReplicateKey",
              "kms:GetKeyRotationStatus"
            ],
            "Resource": "arn:aws:kms:${var.region}:${var.account_id}:key/*"
        },
        {
            "Sid": "Allow Macie to use the key",
            "Effect": "Allow",
            "Principal": {
                "Service": "macie.amazonaws.com"
            },
            "Action": [
                "kms:GenerateDataKey",
                "kms:Encrypt"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.account_id}"
                },
                "ArnLike": {
                    "aws:SourceArn": [
                        "arn:aws:macie2:${var.region}:${var.account_id}:export-configuration:*",
                        "arn:aws:macie2:${var.region}:${var.account_id}:classification-job/*"
                    ]
                }
            }
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:role/aws-service-role/macie.amazonaws.com/AWSServiceRoleForAmazonMacie"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey",
                "kms:GetKeyRotationStatus"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:role/aws-service-role/macie.amazonaws.com/AWSServiceRoleForAmazonMacie"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
      ]
    }
EOT
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
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-piimetadata-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
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
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-athenaresults-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
}

resource "aws_kms_alias" "athenaresults_kms_key" {
  name          = "alias/${local.application_use}-athenaresults_kms_key"
  target_key_id = aws_kms_key.athenaresults_kms_key.key_id
}

resource "aws_kms_key" "sns_lambda_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-sns-lambda-kms-key"
    },
  )
  policy = data.aws_iam_policy_document.kms_default_policy.json
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

resource "aws_kms_grant" "ccc_macie_scan_trigger_lambda" {
  name              = "${local.application_use}-lambda_role_kms_key_6"
  key_id            = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.trigger_macie_lambda_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

module "sns_kms_key" {
  source           = "app.terraform.io/SempraUtilities/seu-kms/aws"
  version          = "10.0.0"
  description      = local.description
  aws_region       = local.region
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${var.application_use}-sns-kms-key" # application_name = "${local.application_name}-sns"
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-kms-nla-key-sns"
    },
  )
  policy = <<EOT
      {
        "Version": "2012-10-17",
        "Id": "KMS-Key-Policy",
        "Statement": [
            {
              "Sid": "Enable IAM User Permissions",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::${var.account_id}:root"
              },
              "Action": "kms:*",
              "Resource": "*"
            },
            {
              "Sid": "Allow Cloudwatch access for CMK",
              "Effect": "Allow",
              "Principal": {
                  "Service":[ "cloudwatch.amazonaws.com" ]
              },
              "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
              ],
              "Resource": "*"
            },
            {
              "Sid": "Allow Eventbridge access for SNS Key",
              "Effect": "Allow",
              "Principal": {
                  "Service":[ "events.amazonaws.com" ]
              },
              "Action": "kms:*",
              "Resource": "*"
            }			
        ]
      }
  EOT  
}

module "sqs_nla_kms_key" {
  source           = "app.terraform.io/SempraUtilities/seu-kms/aws"
  version          = "10.0.0"
  description      = local.description
  aws_region       = local.region
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${var.application_use}-sqs-nla-kms-key" # application_name = "${local.application_name}-sns"
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-kms-nla-key-sqs"
    },
  )
  policy = <<EOT
      {
      "Version": "2012-10-17",
      "Id": "SQS-Key-Policy",
      "Statement": [
          {
              "Sid": "Enable IAM Root User Permissions for KMS",
              "Effect": "Allow",
              "Principal": {
                  "AWS": [
                      "arn:aws:iam::${var.account_id}:root",
                      "arn:aws:iam::${var.insights_account_id}:root"
                    ]
              },
              "Action": [
                "kms:*"
              ],
              "Resource": "arn:aws:kms:${var.region}:${var.account_id}:key/*"
          }    
      ]
    }
  EOT
}

