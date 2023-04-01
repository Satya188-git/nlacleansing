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

# provider "aws" {
#   alias  = "west"
#   region = "us-west-2"
#   assume_role {
#     role_arn     = var.aws_assume_role
#     session_name = "AWS-STSSession-TF"
#   }
# }
# module "nla_replication_role" {

#   source            = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
#   version           = "4.0.2"
#   company_code      = local.company_code
#   application_code  = local.application_code
#   environment_code  = local.environment_code
#   region_code       = local.region_code
#   application_use   = "${local.application_use}-s3-replication-role"
#   service_resources = ["s3.amazonaws.com"]

#   tags = merge(
#     local.tags,
#     {
#       name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-${local.application_use}-replication"
#     },
#   )
# }
# data "aws_iam_policy_document" "replication_role_document" {
#   version = "2012-10-17"
#   statement {
#     effect = "Allow"
#     actions = [
#       "sts:AssumeRole",
#     ]
#     principals {
#       type = "Service"
#       identifiers = [
#         "s3.amazonaws.com"
#       ]
#     }
#   }
# }
# resource "aws_iam_policy" "replication" {
#   name        = "nla_replication_role_policy"
#   description = "Policy to allow replication to the bucket"
#   policy      = data.aws_iam_policy_document.replication_policy.json
# }
# # Attach the permission polcy created above to the role.
# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = module.nla_replication_role.name
#   policy_arn = aws_iam_policy.replication.arn
# }
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
  versioning                     = true
  tags                           = local.tags

  acl = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_verified_clean_arn
        sse_algorithm     = "aws:kms"
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

# #source replication configuration
# resource "aws_s3_bucket_replication_configuration" "insights_bucket_replication_rule" {
#   provider = aws.west
#   # Must have bucket versioning enabled first
#   depends_on = [module.ccc_verified_clean_bucket.s3_bucket_id, module.nla_replication_role.arn, module.insights_verified_clean_bucket.s3_bucket_arn]

#   # role   = var.nla_replication_role_arn
#   role   = module.nla_replication_role.arn
#   bucket = module.ccc_verified_clean_bucket.s3_bucket_id


#   rule {
#     id = "insights_bucket_replication_rule"

#     filter {
#       prefix = "final_outputs/"
#     }

#     status = "Disabled"
#     source_selection_criteria {
#       sse_kms_encrypted_objects {
#         status = "Enabled"
#       }
#     }
#     destination {
#       account = data.aws_caller_identity.destination_acc_id.account_id
#       # bucket        = "arn:aws:s3:::ccc-verified-cleaned-nla-temp"
#       bucket        = module.insights_verified_clean_bucket.arn
#       storage_class = "STANDARD"
#       encryption_configuration {
#         replica_kms_key_id = "arn:aws:kms:us-west-2:713342716921:key/b71c79be-8406-4ade-8db7-6e68467f46e4"
#       }
#     }

#   }
# }

# # source object ownership
# resource "aws_s3_bucket_ownership_controls" "ccc_verified_clean_bucket" {
#   bucket = module.ccc_verified_clean_bucket.s3_bucket_id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }
# # source bucket policy
# data "aws_iam_policy_document" "insights_source_policy" {
#   version = "2012-10-17"
#   statement {
#     actions = [
#       "s3:ListBucket",
#       "s3:GetReplicationConfiguration",
#       "s3:GetObjectVersionForReplication",
#       "s3:GetObjectVersionAcl",
#       "s3:GetObjectVersionTagging",
#       "s3:GetObjectVersion",
#       "s3:ObjectOwnerOverrideToBucketOwner"
#     ]
#     effect = "Allow"
#     resources = [
#       "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-verified-clean",
#       "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-verified-clean/*"
#     ]
#   }
#   statement {
#     actions = [
#       "s3:ReplicateObject",
#       "s3:ReplicateDelete",
#       "s3:ReplicateTags",
#       "s3:GetObjectVersionTagging",
#       "s3:ObjectOwnerOverrideToBucketOwner"
#     ]
#     effect    = "Allow"
#     resources = ["arn:aws:s3:::ccc-verified-cleaned-nla-temp/*"]
#   }
#   statement {
#     actions = [
#       "kms:Decrypt"
#     ]
#     effect    = "Allow"
#     resources = ["arn:aws:kms:us-west-2:183095018968:key/551d47b3-97af-415b-ae31-71b6b7bc4cc0"]
#   }
#   statement {
#     actions = [
#       "kms:Encrypt"
#     ]
#     effect    = "Allow"
#     resources = ["arn:aws:kms:us-west-2:713342716921:key/b71c79be-8406-4ade-8db7-6e68467f46e4"]
#   }

# }
# resource "aws_s3_bucket_policy" "ccc_verified_clean_bucket" {
#   bucket = module.ccc_verified_clean_bucket.s3_bucket_id
#   policy = data.aws_iam_policy_document.insights_source_policy.json
# }


# # verified cllean replication bucket
# module "insights_verified_clean_bucket" {
#   source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
#   version                        = "5.3.0"
#   company_code                   = local.company_code
#   application_code               = local.application_code
#   environment_code               = local.environment_code
#   region_code                    = local.region_code
#   application_use                = "${local.application_use}-insights-verified-clean"
#   owner                          = "NLA Team"
#   create_bucket                  = true
#   create_log_bucket              = false
#   attach_alb_log_delivery_policy = false
#   versioning                     = true
#   tags                           = local.tags

#   acl = "private"
#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         kms_master_key_id = var.kms_key_ccc_verified_clean_arn
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }
#   cors_rule = [
#     {
#       allowed_methods = ["GET", "PUT", "POST"]
#       allowed_origins = ["*"]
#       allowed_headers = ["*"]
#       expose_headers  = []
#     }
#   ]
# }
# TODO add replication config

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
  additional_policy_statements = [
    {
      "Sid"       = "AllowSSLRequestsOnly",
      "Effect"    = "Deny",
      "Principal" = "*",
      "Action"    = "s3:*",
      "Resource" = [
        "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings",
        "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings/*"
      ],
      "Condition" = {
        "Bool" = {
          "aws:SecureTransport" = "false"
        }
      }
    },
    {
      "Sid"    = "Allow Macie to upload objects to the bucket",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "macie.amazonaws.com"
      },
      "Action"   = "s3:PutObject",
      "Resource" = "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings/*",
      "Condition" = {
        "StringEquals" = {
          "aws:SourceAccount" : "183095018968"
        },
        "ArnLike" = {
          "aws:SourceArn" = [
            "arn:aws:macie2:us-west-2:183095018968:export-configuration:*",
            "arn:aws:macie2:us-west-2:183095018968:classification-job/*"
          ]
        }
      }
    },
    {
      "Sid"    = "Allow Macie to use the getBucketLocation operation",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "macie.amazonaws.com"
      },
      "Action"   = "s3:GetBucketLocation",
      "Resource" = "arn:aws:s3:::sdge-dtdes-dev-wus2-s3-nla-macie-findings",
      "Condition" = {
        "StringEquals" = {
          "aws:SourceAccount" = "183095018968"
        },
        "ArnLike" = {
          "aws:SourceArn" = [
            "arn:aws:macie2:us-west-2:183095018968:export-configuration:*",
            "arn:aws:macie2:us-west-2:183095018968:classification-job/*"
          ]
        }
      }
    }
  ]
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
