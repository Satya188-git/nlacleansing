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
module "comprehend_lambda_role" {
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source = "app.terraform.io/SempraUtilities/seu-iam-role/aws"

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
  source  = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
  version = "4.0.2"

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

# custom policies
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
          "Resource" = "arn:aws:kms:*:544868842803:key/*"
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

# Policies

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
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
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
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
  role       = module.comprehend_lambda_role.name
}

# transribe lambda permissions
resource "aws_iam_role_policy_attachment" "AmazonTranscribeFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
  role       = module.transcribe_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "TranscribeAmazonAthenaFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
  role       = module.transcribe_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "TranscribeAmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
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

#  audit call lambda
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole8" {
  role       = module.audit_call_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AuditAmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
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
