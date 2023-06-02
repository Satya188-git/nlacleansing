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
  version                        = "5.3.2"
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
  force_destroy                  = true
  versioning                     = true
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = "alias/aws/kms" # revert to aws s3 managed key after provider bug workaround 
        kms_master_key_id = var.kms_key_ccc_unrefined_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_initial_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
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
  acl                            = "private"
  force_destroy                  = true
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = "alias/aws/kms" # revert to aws s3 managed key after provider bug workaround
        kms_master_key_id = var.kms_key_ccc_initial_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_cleaned_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
  company_code                   = local.company_code
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_clean_arn
        # kms_master_key_id = "alias/aws/kms" # revert to customer managed key after provider bug workaround
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_verified_clean_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  application_use                = "${local.application_use}-verified-clean"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  versioning                     = true
  tags                           = local.tags
  force_destroy                  = true
  acl                            = "private"
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_dirty_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
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
  acl                            = "private"
  force_destroy                  = true

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_dirty_arn
        # kms_master_key_id = "alias/aws/kms" # revert to customer managed key after provider bug workaround
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_maciefindings_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
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
  force_destroy                  = true
  acl                            = "private"
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_maciefindings_arn
        # kms_master_key_id = "alias/aws/kms" # revert to customer managed key after provider bug workaround
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]

  additional_policy_statements = [
    {
      Sid    = "Allow Macie to upload objects to the bucket"
      Effect = "Allow"
      Principal = {
        Service = ["macie.amazonaws.com"]
      }
      Action   = ["s3:PutObject"],
      Resource = "${module.ccc_maciefindings_bucket.s3_bucket_arn}/*",
      Condition = {
        StringEquals = {
          "aws:SourceAccount" : "${var.account_id}"
        }
        ArnLike = {
          "aws:SourceArn" = [
            "arn:aws:macie2:${var.region}:${var.account_id}:export-configuration:*",
            "arn:aws:macie2:${var.region}:${var.account_id}:classification-job/*"
          ]
        }
      }
    },
    {
      Sid    = "Allow Macie to use the getBucketLocation operation"
      Effect = "Allow"
      Principal = {
        Service = ["macie.amazonaws.com"]
      }
      Action   = ["s3:GetBucketLocation"],
      Resource = "${module.ccc_maciefindings_bucket.s3_bucket_arn}",
      Condition = {
        StringEquals = {
          "aws:SourceAccount" : "${var.account_id}"
        }
        ArnLike = {
          "aws:SourceArn" = [
            "arn:aws:macie2:${var.region}:${var.account_id}:export-configuration:*",
            "arn:aws:macie2:${var.region}:${var.account_id}:classification-job/*"
          ]
        }
      }
    }
  ]
}


module "ccc_piimetadata_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
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
  force_destroy                  = true
  acl                            = "private"
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_piimetadata_arn
        # kms_master_key_id = "alias/aws/kms"
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_athenaresults_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "5.3.2"
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
  force_destroy                  = true
  acl                            = "private"
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_athenaresults_arn
        # kms_master_key_id = "alias/aws/kms" # revert to customer managed key after provider bug workaround
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


module "ccc_insights_audio_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.2"

  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${local.application_use}-audio"
  create_bucket    = true
  force_destroy    = true
  versioning       = true
  tags             = local.tags
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_unrefined_arn
        # kms_master_key_id = "alias/aws/s3" # revert to customer managed key after provider bug workaround
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    expiration = [
      {
        days = 2192
      },
    ]
  }]
}


#source replication configuration
resource "aws_s3_bucket_replication_configuration" "insights_bucket_replication_rule" {
  # Must have bucket versioning enabled first
  depends_on = [module.ccc_verified_clean_bucket.s3_bucket_id, var.nla_replication_role_arn]

  role   = var.nla_replication_role_arn
  bucket = module.ccc_verified_clean_bucket.s3_bucket_id

  rule {
    id = "insights_bucket_replication_rule"
    delete_marker_replication {
      status = "Disabled"
    }

    filter {
      prefix = "final_outputs/"
    }

    status = "Enabled"
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      account = var.insights_account_id
      bucket  = var.s3bucket_insights_replication_arn
      encryption_configuration {
        replica_kms_key_id = var.insights_s3kms_arn
      }
      access_control_translation {
        owner = "Destination"
      }
    }
  }
}


resource "aws_s3_bucket_replication_configuration" "unrefined_bucket_replication_rule" {
  # Must have bucket versioning enabled first
  depends_on = [module.ccc_unrefined_call_data_bucket.s3_bucket_id]

  role   = var.nla_replication_role_arn
  bucket = module.ccc_unrefined_call_data_bucket.s3_bucket_id

  rule {
    id = "unrefined_bucket_replication_rule"
    delete_marker_replication {
      status = "Disabled"
    }

    status = "Enabled"
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    filter {}

    destination {
      bucket  = module.ccc_insights_audio_bucket.s3_bucket_arn
      encryption_configuration {
        replica_kms_key_id = var.kms_key_ccc_unrefined_arn
      }
    }
  }
}


resource "aws_s3_bucket_notification" "unrefined_call_data_bucket_notification" {
  bucket      = module.ccc_unrefined_call_data_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_initial_bucket_notification" {
  bucket      = module.ccc_initial_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_cleaned_bucket_notification" {
  bucket      = module.ccc_cleaned_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_verified_clean_bucket_notification" {
  bucket      = module.ccc_verified_clean_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_dirty_bucket_notification" {
  bucket      = module.ccc_dirty_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_maciefindings_bucket_notification" {
  bucket      = module.ccc_maciefindings_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_piimetadata_bucket_notification" {
  bucket      = module.ccc_piimetadata_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_athenaresults_bucket_notification" {
  bucket      = module.ccc_athenaresults_bucket.s3_bucket_id
  eventbridge = true
}
