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

# Customercallcenterpiiunrefined 
# ccc-unrefined-call-data-bucket
module "ccc_unrefined_call_data_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-unrefined"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags
  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_unrefined_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# customercallcenterpiitranscription
# ccc-initial-bucket
module "ccc_initial_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-pii-transcription"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_initial_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# Customercallcenterpiicleaned
# ccc-clean-bucket
module "ccc_cleaned_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-cleaned"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_clean_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# Customercallcenterpiicleanedverified
# ccc-verified-clean-bucket
module "ccc_verified_clean_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-verified-clean"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_verified_clean_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# customercallcenterpiidirty
# ccc-dirty-bucket
module "ccc_dirty_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-dirty"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_dirty_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# customercallcentermaciefindings
module "ccc_maciefindings_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-macie-findings"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_maciefindings_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# customercallcenterpiimetadata
module "ccc_piimetadata_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-pii-metadata"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_piimetadata_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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

# customercallcenterathenaresults
module "ccc_athenaresults_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "5.3.0"
  company_code      = local.company_code
  application_code  = local.application_code
  environment_code  = local.environment_code
  region_code       = local.region_code
  application_use   = "${local.application_use}-athena-results"
  owner                          = "IAC Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = local.tags

  acl = "private"
  server_side_encryption_configuration = { 
    rule = {
      apply_server_side_encryption_by_default = {
        # kms_master_key_id = var.kms_key_ccc_athenaresults_arn
        # sse_algorithm = "aws:kms"
        sse_algorithm       = "AES256"
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
