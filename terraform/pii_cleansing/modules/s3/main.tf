locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  tags = {
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

module "ccc_unrefined_call_data_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-unrefined"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags
  acl                            = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "alias/aws/s3"
        # kms_master_key_id = var.kms_key_ccc_unrefined_arn
        # sse_algorithm = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
module "ccc_initial_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-pii-transcription"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "alias/aws/s3"
        # kms_master_key_id = var.kms_key_ccc_initial_arn
        # sse_algorithm = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
module "ccc_cleaned_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-cleaned"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_clean_arn
        sse_algorithm     = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
module "ccc_verified_clean_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-verified-clean"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_verified_clean_arn
        sse_algorithm     = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
module "ccc_dirty_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-dirty"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_dirty_arn
        sse_algorithm     = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
module "ccc_maciefindings_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-macie-findings"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_maciefindings_arn
        sse_algorithm     = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
  additional_policy_statements = jsonencode([{
    "Version" : "2012-10-17",
    "Id" : "DenyHttpAccess",
    "Statement" : [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings",
          "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      },
      {
        "Sid" : "Allow Macie to upload objects to the bucket",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "macie.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings/*",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "183095018968"
          },
          "ArnLike" : {
            "aws:SourceArn" : [
              "arn:aws:macie2:us-west-2:183095018968:export-configuration:*",
              "arn:aws:macie2:us-west-2:183095018968:classification-job/*"
            ]
          }
        }
      },
      {
        "Sid" : "Allow Macie to use the getBucketLocation operation",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "macie.amazonaws.com"
        },
        "Action" : "s3:GetBucketLocation",
        "Resource" : "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "183095018968"
          },
          "ArnLike" : {
            "aws:SourceArn" : [
              "arn:aws:macie2:us-west-2:183095018968:export-configuration:*",
              "arn:aws:macie2:us-west-2:183095018968:classification-job/*"
            ]
          }
        }
      }
    ]
  }])
}

module "ccc_piimetadata_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-pii-metadata"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_piimetadata_arn
        sse_algorithm     = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
module "ccc_athenaresults_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.0"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-athena-results"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_athenaresults_arn
        sse_algorithm     = "aws:kms"
        # sse_algorithm       = "AES256"
      }
    }
  }
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]
      expose_headers  = []
    }
  ]
}
