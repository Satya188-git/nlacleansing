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
    # "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    "sempra:gov:unit"   = var.unit 				# unit                = var.unit
    portfolio           = var.portfolio
    support-group       = var.support-group
    "sempra:gov:environment" = var.environment 	# environment         = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

# Define IAM roles
module "nla_replication_role" {

  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-s3-replication-role"
  service_resources = ["s3.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-replication"
    },
  )
}

module "comprehend_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-comprehend"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-comprehend"
    },
  )
}
module "transcribe_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-transcribe"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-transcribe"
    },
  )
}
module "informational_macie_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-macie-info"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-macie-info"
    },
  )
}

module "trigger_macie_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-trigger-macie"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-trigger-macie"
    },
  )
}

module "sns_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-sns"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-sns"
    },
  )
}

module "athena_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-athena"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-athena"
    },
  )
}
module "audit_call_lambda_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-audit-call"
  service_resources = ["lambda.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-audit-call"
    },
  )
}

module "autoscaler_iam_role" {
  source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version           = "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-autoscale"
  service_resources = ["application-autoscaling.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-autoscale"
    },
  )
}

module "custom_transcribe_lambda_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-custom-transcribe"
  service_resources = ["transcribe.amazonaws.com"]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-custom-transcribe"
    },
  )
}

// create IAM role for crawler
module "athena_crawler_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
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
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-glue-crawler-role"
    },
  )
}

// create IAM role for audio_copy lambda
module "audio_copy_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-audio-copy-role"
  description       = "IAM role for EDIX audio copy lambda"
  service_resources = ["lambda.amazonaws.com"]
  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-audio-copy-role"
    },
  )
}

#create role to be assumed by NLA Insights call-details lambda for S3 bucket
module "insights_assumed_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-insights-assumed-role"
  description       = "IAM role to be assumed by call-details lambda from the Insights account"
  service_resources = ["lambda.amazonaws.com"]

  additional_policy_statements = [
    {
        "Sid": "InsightsPermission"
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.insights_account_id}:root"
        },
        "Condition": {},
        "Action": "sts:AssumeRole"
    }
  ]

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-insights-assumed-role"
    },
  )
}

# create IAM role for ccc_audio_access_logs_to_cw lambda
module "ccc_audio_access_logs_to_cw_lambda_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-ccc-audio-access-logs-to-cw"
  description       = "IAM role for transfering audio_access_logs_to_cw lambda"
  service_resources = ["lambda.amazonaws.com"]
  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-ccc-audio-access-logs-to-cw"
    },
  )
}

# create IAM role for Insights daily-monitoring-lambda to access PII Dynamodb tables
module "pii-daily-monitoring-role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-pii-daily-monitoring"
  description       = "IAM role for Insights daily-monitoring-lambda to access PII AWS resources (DDB table)"
  service_resources = ["lambda.amazonaws.com"]
  
  additional_policy_statements = [
    {
        "Sid": "InsightsPermissionToAccessPII"
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.insights_account_id}:root"
        },
        "Condition": {},
        "Action": "sts:AssumeRole"
    }
  ]  
  
  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-pii-daily-monitoring"
    },
  )
}

// create IAM role for file_transfer lambda
module "file_transfer_lambda_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-file-transfer-lambda-role"
  description       = "IAM role for file transfer lambda"
  service_resources = ["lambda.amazonaws.com"]
  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-file-transfer-lambda-role"
    },
  )
}

# IAM role for nla-access-denied lambda
module "ccc_access_denied_notification_lambda_role" {
  source  			= "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version 			= "10.0.2" # version 			= "10.0.2-prerelease" # version 			= "10.0.1"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-ccc-access-denied-notification"
  description       = "IAM role for acess denied notification lambda"
  service_resources = ["lambda.amazonaws.com"]
  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-ccc-access-denied-notification"
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
          "${var.ccc_verified_clean_bucket_arn}",
          "${var.ccc_verified_clean_bucket_arn}/*",
          "${var.ccc_unrefined_call_data_bucket_arn}",
          "${var.ccc_unrefined_call_data_bucket_arn}/*",
          "${var.ccc_callrecordings_bucket_arn}",
          "${var.ccc_callrecordings_bucket_arn}/*"
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
        "Resource" : [
          "${var.s3bucket_insights_replication_arn}/*",
          "${var.ccc_insights_audio_bucket_arn}/*",
          "${var.ccc_piimetadata_bucket_arn}/*"
        ]
      },
      {
        "Action" : [
          "kms:Decrypt"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${var.kms_key_ccc_verified_clean_arn}",
          "${var.kms_key_ccc_unrefined_arn}",
          "${var.kms_key_ccc_piimetadata_arn}"
        ]
      },
      {
        "Action" : [
          "kms:Encrypt"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:kms:us-west-2:${var.insights_account_id}:key/*",
          "${var.kms_key_ccc_unrefined_arn}",
          "${var.kms_key_ccc_piimetadata_arn}"
        ]
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

resource "aws_iam_policy" "audit_lambda_access_policy" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-audit-lambda-access-policy"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": var.audit_lambda_arn
        }
    ]
  })
}

resource "aws_iam_policy" "s3_put_read_delete" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-s3-put-read-delete"
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
            "s3:DeleteObject",
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
resource "aws_iam_policy" "s3_crawler_role_policy" {
  name        = "S3BucketAccess"
  description = "Get and Put access for S3 bucket"

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
      "Resource": "${var.ccc_piimetadata_bucket_arn}*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "insights_assumed_role_policy" {
  name        = "S3BucketAccessFromInsightsAccount"
  description = "S3 bucket and KMS access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
              "s3:GetObject",
              "s3:GetObjectAttributes"
            ],
            "Effect": "Allow",
            "Resource": [ 
              "${var.ccc_unrefined_call_data_bucket_arn}/*",
              "${var.ccc_insights_audio_bucket_arn}/*" 
            ],
            "Sid": "S3Read"
        },
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Resource": "${var.kms_key_ccc_unrefined_arn}",
            "Sid": "KmsUsage"
        }
    ]
}
EOF
}

# sns policy for access denied notification lambda
resource "aws_iam_policy" "sns_subscribe_publish" {
  name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-sns-subscribe-publish"
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Action" = [
            "sns:Publish",
            "sns:Subscribe",
            "sns:CreateTopic",
            "sns:ListTopics", 
            "sns:SetTopicAttributes", 
            "sns:DeleteTopic"
          ],
          "Resource" = "${var.access_denied_notification_topic_arn}"
        }
      ]
  })
}

# Policies
# replication policies
resource "aws_iam_role_policy_attachment" "s3_replication_role_policy" {
  policy_arn = aws_iam_policy.s3_replication_policy.arn
  role       = module.nla_replication_role.name
}

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

resource "aws_iam_role_policy_attachment" "s3_put_read_delete" {
  policy_arn = aws_iam_policy.s3_put_read_delete.arn
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "ComprehendAmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.comprehend_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "ComprehendAuditLambdaAccess" {
  policy_arn = aws_iam_policy.audit_lambda_access_policy.arn
  role       = module.comprehend_lambda_role.name
}
# transribe lambda permissions
resource "aws_iam_role_policy_attachment" "TranscribeAmazonTranscribeFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
  role       = module.transcribe_lambda_role.name
}

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

resource "aws_iam_role_policy_attachment" "transcribeAuditLambdaAccess" {
  policy_arn = aws_iam_policy.audit_lambda_access_policy.arn
  role       = module.transcribe_lambda_role.name
}

# info macie
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole3" {
  role       = module.informational_macie_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "InfoMacieAmazonMacieFullAccess" {
  role       = module.informational_macie_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonMacieFullAccess"
}

resource "aws_iam_role_policy_attachment" "InfoMacieAmazonS3FullAccess" {
  role       = module.informational_macie_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "info_macie_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.informational_macie_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "info_macie_iam_pass_role_policy" {
  policy_arn = aws_iam_policy.iam_pass_role_policy.arn
  role       = module.informational_macie_lambda_role.name
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

resource "aws_iam_role_policy_attachment" "MacieTriggerAuditLambdaAccess" {
  policy_arn = aws_iam_policy.audit_lambda_access_policy.arn
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

resource "aws_iam_role_policy_attachment" "glue_crawler_attachment1" {
  role       = module.athena_crawler_role.id
  policy_arn = aws_iam_policy.s3_crawler_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_crawler_attachment2" {
  role       = module.athena_crawler_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueDataBrewServiceRole"
}

resource "aws_iam_role_policy_attachment" "athena_crawler_managed1" {
  role       = module.athena_crawler_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "athena_crawler_managed2" {
  role       = module.athena_crawler_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "athena_crawler_managed3" {
  role       = module.athena_crawler_role.id
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "athena_crawler_managed4" {
  role       = module.athena_crawler_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "athena_crawler_role_kms_full_access" {
  policy_arn = aws_iam_policy.kms_full_access.arn
  role       = module.athena_crawler_role.name
}

resource "aws_iam_role_policy_attachment" "insights_assumed_role_policy" {
  policy_arn = aws_iam_policy.insights_assumed_role_policy.arn
  role       = module.insights_assumed_role.name
}

resource "aws_iam_role_policy_attachment" "audio_copy_AWSLambdaBasicExecutionRole" {
  role       = module.audio_copy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "audio_copy_S3FullAccess" {
  role       = module.audio_copy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "audio_copy_kms_full_access" {
  role       = module.audio_copy_role.name
  policy_arn = aws_iam_policy.kms_full_access.arn
}

resource "aws_iam_role_policy_attachment" "ccc_audio_access_logs_to_cw_AWSLambdaBasicExecutionRole" {
  role       = module.ccc_audio_access_logs_to_cw_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "ccc_audio_access_logs_to_cw_s3_put_read_delete" {
  role       = module.ccc_audio_access_logs_to_cw_lambda_role.name
  policy_arn = aws_iam_policy.s3_put_read_delete.arn
}

resource "aws_iam_role_policy_attachment" "ccc_audio_access_logs_to_cw_kms_full_access" {
  role       = module.ccc_audio_access_logs_to_cw_lambda_role.name
  policy_arn = aws_iam_policy.kms_full_access.arn
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = module.pii-daily-monitoring-role.name
}


resource "aws_iam_role_policy_attachment" "file_transfer_AWSLambdaBasicExecutionRole" {
  role       = module.file_transfer_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "file_transfer_kms_full_access" {
  role       = module.file_transfer_lambda_role.name
  policy_arn = aws_iam_policy.kms_full_access.arn
}

resource "aws_iam_role_policy_attachment" "file_transfer_s3_put_read_delete" {
  role       = module.file_transfer_lambda_role.name
  policy_arn = aws_iam_policy.s3_put_read_delete.arn
}

resource "aws_iam_role_policy_attachment" "ccc_access_denied_notification_AWSLambdaBasicExecutionRole" {
  role       = module.ccc_access_denied_notification_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "ccc_access_denied_notification_kms_full_access" {
  role       = module.ccc_access_denied_notification_lambda_role.name
  policy_arn = aws_iam_policy.kms_full_access.arn
}

resource "aws_iam_role_policy_attachment" "ccc_access_denied_notification_s3_put_read_delete" {
  role       = module.ccc_access_denied_notification_lambda_role.name
  policy_arn = aws_iam_policy.s3_put_read_delete.arn
}

resource "aws_iam_role_policy_attachment" "ccc_access_denied_notification_sns_subscribe_publish" {
  role       = module.ccc_access_denied_notification_lambda_role.name
  policy_arn = aws_iam_policy.sns_subscribe_publish.arn
}