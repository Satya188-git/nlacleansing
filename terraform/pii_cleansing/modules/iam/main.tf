locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  owner            = var.owner
  tags = {
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    unit                = var.unit
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

# Define IAM roles
module "nla_replication_role" {

  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-s3-replication-role"
  service_resources = ["s3.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-replication"
    },
  )
}

module "comprehend_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-comprehend"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-comprehend"
    },
  )
}
module "transcribe_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-transcribe"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-transcribe"
    },
  )
}
module "informational_macie_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-macie-info"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-macie-info"
    },
  )
}
module "macie_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-macie"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-macie"
    },
  )
}

module "trigger_macie_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-trigger-macie"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-trigger-macie"
    },
  )
}

module "sns_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-sns"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-sns"
    },
  )
}
module "athena_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-athena"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-athena"
    },
  )
}
module "audit_call_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-audit-call"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-audit-call"
    },
  )
}

module "autoscaler_iam_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version           = "4.0.2"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-autoscale"
  service_resources = ["application-autoscaling.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-autoscale"
    },
  )
}

module "custom_transcribe_lambda_role" {
  source  = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version = "4.0.2"

  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-custom-transcribe"
  service_resources = ["transcribe.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-custom-transcribe"
    },
  )
}

// create IAM role for crawler
module "athena_crawler_role" {
  source  = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version = "4.0.2"

  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-glue-crawler-role"
  description       = "IAM role for Athena Glue Crawler"
  service_resources = ["glue.amazonaws.com"]
  tags = merge(
    local.tags,
    {
      name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-glue-crawler-role"
    },
  )
}


# custom policies

resource "aws_iam_policy" "s3_replication_policy" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-s3-replication-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectVersion",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-verified-clean",
          "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-verified-clean/*"
        ]
      },
      {
        "Action" : [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::ccc-verified-cleaned-nla-temp/*"
      },
      {
        "Action" : [
          "kms:Decrypt"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:kms:us-west-2:${var.account_id}:key/551d47b3-97af-415b-ae31-71b6b7bc4cc0"
      },
      {
        "Action" : [
          "kms:Encrypt"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:kms:us-west-2:713342716921:key/b71c79be-8406-4ade-8db7-6e68467f46e4"
      }
    ]
  })
}
resource "aws_iam_policy" "iam_pass_role_policy" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-pass-role-policy"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect"   = "Allow",
          "Action"   = "iam:PassRole",
          "Resource" = "*"
        }
      ]
  })
}

resource "aws_iam_policy" "kms_full_access" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-kms-full-access"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect"   = "Allow",
          "Action"   = "kms:*",
          "Resource" = "arn:aws:kms:*:${var.account_id}:key/*"
        }
      ]
  })
}

resource "aws_iam_policy" "s3_put_read" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-s3-put-read"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Action" = [
            "s3:Get*",
            "s3:List*",
            "s3:Put*",
            "s3-object-lambda:Get*",
            "s3-object-lambda:List*",
            "s3-object-lambda:Put*"
          ],
          "Resource" = "*"
        }
      ]
  })
}

resource "aws_iam_policy" "custom_transcribe_lambda_policy" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-custom-transcribe-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "s3:GetObject"
          ],
          "Resource" : [
            "${var.ccc_unrefined_call_data_bucket_arn}/*"
          ],
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "s3:ListBucket"
          ],
          "Resource" : [
            "${var.ccc_unrefined_call_data_bucket_arn}"
          ],
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "kms:Decrypt"
          ],
          "Resource" : [
            "arn:aws:kms:us-west-2:${var.account_id}:key/*"
          ],
          "Condition" : {
            "StringLike" : {
              "kms:ViaService" : [
                "s3.*.amazonaws.com"
              ]
            }
          },
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters",
            "ssm:GetParameter",
            "ssm:GetParametersByPath"
          ],
          "Resource" : "arn:aws:ssm:us-west-2::parameter/*"
        }
      ]
  })
}

// create policy
resource "aws_iam_policy" "athena_crawler_role_policy" {
  name        = "AthenaBucketAccess"
  description = "Get and Put access for Athena bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${var.ccc_athenaresults_bucket_arn}*"
    }
  ]
}
EOF
}

# Policies
# replication policies
resource "aws_iam_role_policy_attachment" "s3_replication_role_policy" {
  policy_arn = aws_iam_policy.s3_replication_policy.arn
  role       = module.nla_replication_role.name
}
resource "aws_iam_policy_attachment" "assume_role_policy" {
  name       = "assume-role-policy"
  policy_arn = var.aws_assume_role_insights
  users      = [var.aws_assume_role_user_pii]
}
# comprehend lambda permissions
resource "aws_iam_role_policy_attachment" "AmazonComprehendFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/ComprehendFullAccess"
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole1" {
  role       = module.comprehend_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "ComprehendAmazonAthenaFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "comprehend_iam_pass_role_policy" {
  policy_arn = aws_iam_policy.iam_pass_role_policy.arn
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "comprehend_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "s3_put_read" {
  policy_arn = aws_iam_policy.s3_put_read.arn
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "ComprehendAmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.comprehend_lambda_role.name
}

# transribe lambda permissions
resource "aws_iam_role_policy_attachment" "TranscribeAmazonTranscribeFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
  role       = module.transcribe_lambda_role.name
}

# resource "aws_iam_role_policy_attachment" "TranscribeAmazonAthenaFullAccess" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
#   role       = module.transcribe_lambda_role.name
# }

resource "aws_iam_role_policy_attachment" "TranscribeAmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.transcribe_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = module.transcribe_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole2" {
  role       = module.transcribe_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "transcribe_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.transcribe_lambda_role.name
}
resource "aws_iam_role_policy_attachment" "transcribe_iam_pass_role_policy" {
  policy_arn = aws_iam_policy.iam_pass_role_policy.arn
  role       = module.transcribe_lambda_role.name
}

# macie lambda role
resource "aws_iam_role_policy_attachment" "MacieAmazonMacieFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonMacieFullAccess"
  role       = module.macie_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole4" {
  role       = module.macie_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# macie info lambda role
resource "aws_iam_role_policy_attachment" "macie_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.macie_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "macie_iam_pass_role_policy" {
  policy_arn = aws_iam_policy.iam_pass_role_policy.arn
  role       = module.macie_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "MacieAmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.macie_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "MacieAmazonAthenaFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
  role       = module.macie_lambda_role.name
}
resource "aws_iam_role_policy_attachment" "AmazonMacieFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonMacieFullAccess"
  role       = module.macie_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole3" {
  role       = module.informational_macie_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# trigger macie lambda role
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole5" {
  role       = module.trigger_macie_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "macie_trigger_iam_pass_role_policy" {
  policy_arn = aws_iam_policy.iam_pass_role_policy.arn
  role       = module.trigger_macie_lambda_role.name
}
resource "aws_iam_role_policy_attachment" "macie_trigger_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.trigger_macie_lambda_role.name
}
resource "aws_iam_role_policy_attachment" "MacieTriggerAmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.trigger_macie_lambda_role.name
}
resource "aws_iam_role_policy_attachment" "MacieTriggerAmazonMacieFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonMacieFullAccess"
  role       = module.trigger_macie_lambda_role.name
}
#  audit call lambda
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole8" {
  role       = module.audit_call_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AuditAmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = module.audit_call_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = module.audit_call_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole6" {
  role       = module.sns_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AmazonAthenaFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
  role       = module.athena_lambda_role.name
}
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole7" {
  role       = module.athena_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# transcribe_bucket_access_role
resource "aws_iam_role_policy_attachment" "CustomTranscribeAmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.custom_transcribe_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "CustomAmazonTranscribeFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
  role       = module.custom_transcribe_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "transcribe_custom_s3_policy" {
  policy_arn = aws_iam_policy.custom_transcribe_lambda_policy.arn
  role       = module.custom_transcribe_lambda_role.name
}

# attach policy for athena glue crawler
resource "aws_iam_role_policy_attachment" "athena_crawler_attachment" {
  role       = module.athena_crawler_role.id
  policy_arn = aws_iam_policy.athena_crawler_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "athena_crawler_managed" {
  role       = module.athena_crawler_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}


resource "aws_iam_role_policy_attachment" "athena_crawler_role_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.athena_crawler_role.name
}
