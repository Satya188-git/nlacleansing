locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  tags = {
    "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
	"sempra:gov:unit"   = var.unit 				# unit                = var.unit
    billing-guid        = var.billing-guid
    portfolio           = var.portfolio
    support-group       = var.support-group
    "sempra:gov:environment" = var.environment 	# environment         = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}


# Enable tfartifacts bucket versioning
data "aws_s3_bucket" "tfartifacts" {
  bucket = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-s3-tf-artifacts"
}

resource "aws_s3_bucket_versioning" "tfartifacts_versioning" {
  bucket = data.aws_s3_bucket.tfartifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

module "ccc_unrefined_call_data_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-unrefined"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-unrefined"
    },
  )
  acl                            = "private"
  force_destroy                  = true
  versioning                     = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
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
        days = 90
      },
    ]
  }]
}


module "ccc_initial_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-pii-transcription"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-transcription"
    },
  )
  acl                            = "private"
  force_destroy                  = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
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
    filter  = [
      {
        prefix  = "standard_full_transcripts/"
      },
    ]
    expiration = [
      {
        days = 90
      },
    ]
  },
  { id      = "expiration-rule-standard"
    enabled = true
    filter  = [
      {
        prefix  = "standard/"
      },
    ]
    expiration = [
      {
        days = 90
      },
    ]

  }]
}


module "ccc_cleaned_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-cleaned"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-cleaned"
    },
  )
  force_destroy                  = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
  acl                            = "private"
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
    filter  = [
      {
        prefix  = "final_outputs/"
      },
    ]
    expiration = [
      {
        days = 90
      },
    ]
  },
  {
    id      = "expiration-rule-standard"
    enabled = true
    filter  = [
      {
        prefix  = "standard_full_transcripts/"
      },
    ]
    expiration = [
      {
        days = 90
      },
    ]
  }]
}


module "ccc_verified_clean_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
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
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-verified-clean"
    },
  )
  force_destroy                  = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
  acl                            = "private"
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_verified_clean_arn
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
        days = 730
      },
    ]
  }]
}


module "ccc_dirty_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-dirty"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-dirty"
    },
  )
  acl                            = "private"
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true 
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
    filter  = [
      {
        prefix="standard/"
      },
    ]
    expiration = [
      {
        days = 365
      },
    ]
  }]
}


module "ccc_maciefindings_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-macie-findings"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-macie-findings"
    },
  )
  force_destroy                  = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
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
        days = 180
      },
    ]
  }]

  additional_policy_statements   = [data.aws_iam_policy_document.maciefindings_upload_additional_policies.json,
   data.aws_iam_policy_document.maciefindings_getBucketLocation_additional_policies.json] 

}

data "aws_iam_policy_document" "maciefindings_upload_additional_policies" {
	statement {
	    sid       	= "Allow Macie to upload objects to the bucket"
		effect 		= "Allow"
		principals {
				type = "Service"
				identifiers = ["macie.amazonaws.com"]
		}
		actions 	= ["s3:PutObject"]
		resources 	= ["${module.ccc_maciefindings_bucket.s3_bucket_arn}/*"]
		condition {
                    test = "StringEquals"
                    variable = "aws:SourceAccount"
                    values = ["${var.account_id}"]
            }
		condition {
                    test = "ArnLike"
                    variable = "aws:SourceArn"
                    values = [
							"arn:aws:macie2:${var.region}:${var.account_id}:export-configuration:*",
							"arn:aws:macie2:${var.region}:${var.account_id}:classification-job/*"
                    ]
            }		
	}
}

data "aws_iam_policy_document" "maciefindings_getBucketLocation_additional_policies" {
	statement {
		sid       	= "Allow Macie to use the getBucketLocation operation"
		effect 		= "Allow"
		principals {
				type = "Service"
				identifiers = ["macie.amazonaws.com"]
		}
		actions 	= ["s3:GetBucketLocation"]
		resources 	= ["${module.ccc_maciefindings_bucket.s3_bucket_arn}"]
		condition {
                    test = "StringEquals"
                    variable = "aws:SourceAccount"
                    values = ["${var.account_id}"]
            }
		condition {
                    test = "ArnLike"
                    variable = "aws:SourceArn"
                    values = [
							"arn:aws:macie2:${var.region}:${var.account_id}:export-configuration:*",
							"arn:aws:macie2:${var.region}:${var.account_id}:classification-job/*"
                    ]
            }		
	}
}


module "ccc_piimetadata_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-pii-metadata"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-metadata"
    },
  )
  force_destroy                  = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
  versioning                     = true
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
    id      = "transition-rule"
    enabled = true
    filter  = [
      {
        prefix  = "EDIX_METADATA/"
      },
    ]
    transition = [{
      days          = 720
      storage_class = "GLACIER"
    },
    ]
  }]
}


module "ccc_athenaresults_bucket" {
  source                         = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version                        = "10.0.1"
  company_code                   = local.company_code
  application_code               = local.application_code
  environment_code               = local.environment_code
  region_code                    = local.region_code
  application_use                = "${local.application_use}-athena-results"
  owner                          = "NLA Team"
  create_bucket                  = true
  create_log_bucket              = false
  attach_alb_log_delivery_policy = false
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-athena-results"
    },
  )
  force_destroy                  = true
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
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
        days = 180
      },
    ]
  }]
}


module "ccc_insights_audio_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "10.0.1"

  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${local.application_use}-audio"
  create_bucket    = true
  force_destroy    = true
  versioning       = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-audio"
    },
  )
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
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
    id           = "expiration-rule"
    enabled      = true
    expiration   = [
        {
          days = 2192
        },
    ]
  }]
  additional_policy_statements   = [data.aws_iam_policy_document.insights_audio_deny_iam_role_policies.json,
   data.aws_iam_policy_document.insights_audio_allow_iam_role_policies.json,
   data.aws_iam_policy_document.insights_audio_allow_presignedURL_policies.json]
}

data "aws_iam_policy_document" "insights_audio_deny_iam_role_policies" {
  statement {
    sid       = "DenyNonInsightsAssumedRoleToAudio"
    effect    = "Deny"
    resources = ["${module.ccc_insights_audio_bucket.s3_bucket_arn}/*"]
    actions   = ["s3:*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [var.insights_assumed_role_arn]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
  
data "aws_iam_policy_document" "insights_audio_allow_iam_role_policies" {
  statement {
    sid    = "AllowInsightsAssumedRoleToAudio"
    effect = "Allow"

    resources = [
      "${module.ccc_insights_audio_bucket.s3_bucket_arn}",
      "${module.ccc_insights_audio_bucket.s3_bucket_arn}/*",
    ]

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [var.insights_assumed_role_arn]
    }
  }
}

data "aws_iam_policy_document" "insights_audio_allow_presignedURL_policies" {
  statement {
    sid       = "AllowSSLS3PresignedURLAccessToAudio"
    effect    = "Allow"
    resources = ["${module.ccc_insights_audio_bucket.s3_bucket_arn}/*"]
    actions   = ["s3:GetObject"]

    condition {
      test     = "StringEquals"
      variable = "s3:signatureversion"
      values   = ["AWS4-HMAC-SHA256"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


#############################

module "ccc_callrecordings_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "10.0.1"

  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${local.application_use}-callrecordings"
  create_bucket    = true
  force_destroy    = true
  versioning       = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-callrecordings"
    },
  )
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_ccc_piimetadata_arn
        # kms_master_key_id = "alias/aws/s3" # revert to customer managed key after provider bug workaround
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule = [{
    id      = "expiration-rule"
    enabled = true
    filter  = [
      {
        prefix  = "EDIX_METADATA/"
      },
    ]
    expiration = [
      {
        days = 90
      },
    ]
  }]

  additional_policy_statements   = [   data.aws_iam_policy_document.call_recordings_deny_role_access_additional_policies.json,     
    data.aws_iam_policy_document.allow_EDIX_user_access_additional_policies.json,
    data.aws_iam_policy_document.allow_file_transfer_role_access_additional_policies.json,
    data.aws_iam_policy_document.allow_audio_copy_role_access_additional_policies.json
  ]
  
}


  data "aws_iam_policy_document" "call_recordings_deny_role_access_additional_policies" {
  statement {
    sid       = "DenyNonrequiredAccessToCallRecordings"
    effect    = "Deny"
    resources = ["${module.ccc_insights_audio_bucket.s3_bucket_arn}/*"]
    actions   = ["s3:*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [var.audio_copy_lambda_role_arn]
      #, var.file_transfer_lambda_role_arn,  "arn:aws:iam::${var.account_id}:user/${local.company_code}-${local.application_code}-${local.environment_code}-iam-user-edix"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

  
data "aws_iam_policy_document" "allow_EDIX_user_access_additional_policies" {
    statement {
        sid    = "AllowEdixUserAccessToCallRecordings"
        effect = "Allow"
        resources = [
            "${module.ccc_callrecordings_bucket.s3_bucket_arn}/*",
            "${module.ccc_callrecordings_bucket.s3_bucket_arn}"
        ]
        actions = [ "s3:*" ]
        principals{
            type        = "AWS"
            identifiers = ["arn:aws:iam::${var.account_id}:user/${local.company_code}-${local.application_code}-${local.environment_code}-iam-user-edix"]
        }    
    }
}

data "aws_iam_policy_document" "allow_file_transfer_role_access_additional_policies" {
  statement {
    sid    = "AllowFileTransferRoleToAccessToCallRecordings"
    effect = "Allow"

    resources = [
      "${module.ccc_callrecordings_bucket.s3_bucket_arn}/*",
      "${module.ccc_callrecordings_bucket.s3_bucket_arn}"
    ]

    actions = [ "s3:*" ]

    principals {
      type        = "AWS"
      identifiers = [ var.file_transfer_lambda_role_arn]
    }
  }
}


data "aws_iam_policy_document" "allow_audio_copy_role_access_additional_policies" {
  statement {
    sid    = "AllowAudioCopyRoleToAccessToCallRecordings"
    effect = "Allow"

    resources = [
      "${module.ccc_callrecordings_bucket.s3_bucket_arn}/*",
      "${module.ccc_callrecordings_bucket.s3_bucket_arn}"
    ]

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [var.audio_copy_lambda_role_arn]
    }
  }
}

########################################


module "ccc_callaudioaccesslogs_bucket" {
  source  = "app.terraform.io/SempraUtilities/seu-s3/aws"
  version = "10.0.1"

  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "${local.application_use}-callaudioaccesslogs"
  create_bucket    = true
  force_destroy    = true
  versioning       = true
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-callaudioaccesslogs"
    },
  )
  object_ownership               = "BucketOwnerPreferred"
  control_object_ownership       = true
  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256" 
      }
    }
  }

  lifecycle_rule = [{
    id      = "transition-rule"
    enabled = true
    filter  = [
      {
        prefix  = "log/"
      },
    ]
    transition = [{
      days          = 180
      storage_class = "GLACIER"
    },
    ]
  }]
}



#source to target replication configurations
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


resource "aws_s3_bucket_replication_configuration" "callrecordings_bucket_replication_rule" {
  # Must have bucket versioning enabled first
  depends_on = [module.ccc_callrecordings_bucket.s3_bucket_id, module.ccc_piimetadata_bucket.s3_bucket_id, var.nla_replication_role_arn]

  role   = var.nla_replication_role_arn
  bucket = module.ccc_callrecordings_bucket.s3_bucket_id

  rule {
    id = "callrecordings_metadata_replication_rule"
    delete_marker_replication {
      status = "Disabled"
    }

    status = "Enabled"
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    filter {
      prefix = "EDIX_METADATA/"
    }
    priority = 0

    destination {
      bucket  = module.ccc_piimetadata_bucket.s3_bucket_arn
      encryption_configuration {
        replica_kms_key_id = var.kms_key_ccc_piimetadata_arn
      }
    }
  }

  rule {
    id = "supervisor_data_replication_rule"
    delete_marker_replication {
      status = "Disabled"
    }

    filter {
      prefix = "EDIX_SUPERVISOR/"
    }
    
    priority = 1
    
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

resource "aws_s3_bucket_notification" "ccc_insights_audio_bucket_notification" {
  bucket      = module.ccc_insights_audio_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_bucket_notification" "ccc_callrecordings_bucket_notification" {
  bucket      = module.ccc_callrecordings_bucket.s3_bucket_id
  eventbridge = true
}

resource "aws_s3_bucket_notification" "ccc_callaudioaccesslogs_bucket_notification" {
  bucket      = module.ccc_callaudioaccesslogs_bucket.s3_bucket_id
  eventbridge = true
}


resource "aws_s3_object" "edix_audio_prefix" {
  key        = "EDIX_AUDIO/"
  bucket     = module.ccc_callrecordings_bucket.s3_bucket_id
  source     = "/dev/null"
  kms_key_id = var.kms_key_ccc_piimetadata_arn
}


resource "aws_s3_object" "edix_metadata_prefix" {
  key        = "EDIX_METADATA/"
  bucket     = module.ccc_callrecordings_bucket.s3_bucket_id
  source     = "/dev/null"
  kms_key_id = var.kms_key_ccc_piimetadata_arn
}

resource "aws_s3_object" "edix_supervisor_prefix" {
  key        = "EDIX_SUPERVISOR/"
  bucket     = module.ccc_callrecordings_bucket.s3_bucket_id
  source     = "/dev/null"
  kms_key_id = var.kms_key_ccc_piimetadata_arn
}

resource "aws_s3_object" "access_logs_prefix" {
  key        = "log/"
  bucket     = module.ccc_callaudioaccesslogs_bucket.s3_bucket_id
  source     = "/dev/null"
}

# Encryption configuration
# This is needed vs. using the S3 module ssl configuration because there is a bug in the Terraform Cloud Sentinel that will fail a new account deployment if we are using aws:kms encryption
# This is a solution to get around that bug
resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_unrefined_call_data_bucket_encryption" {
  depends_on = [module.ccc_unrefined_call_data_bucket.s3_ssl_policy]
  bucket = module.ccc_unrefined_call_data_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_unrefined_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_initial_bucket_encryption" {
  depends_on = [module.ccc_initial_bucket.s3_ssl_policy]
  bucket = module.ccc_initial_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_initial_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_cleaned_bucket_encryption" {
  depends_on = [module.ccc_cleaned_bucket.s3_ssl_policy]
  bucket = module.ccc_cleaned_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_clean_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_verified_clean_bucket_encryption" {
  depends_on = [module.ccc_verified_clean_bucket.s3_ssl_policy]
  bucket = module.ccc_verified_clean_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_verified_clean_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_dirty_bucket_encryption" {
  depends_on = [module.ccc_dirty_bucket.s3_ssl_policy]
  bucket = module.ccc_dirty_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_dirty_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_maciefindings_bucket_encryption" {
  depends_on = [module.ccc_maciefindings_bucket.s3_ssl_policy]
  bucket = module.ccc_maciefindings_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_maciefindings_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_piimetadata_bucket_encryption" {
  depends_on = [module.ccc_piimetadata_bucket.s3_ssl_policy]
  bucket = module.ccc_piimetadata_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_piimetadata_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_athenaresults_bucket_encryption" {
  depends_on = [module.ccc_athenaresults_bucket.s3_ssl_policy]
  bucket = module.ccc_athenaresults_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_athenaresults_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_insights_audio_bucket_encryption" {
  depends_on = [module.ccc_insights_audio_bucket.s3_ssl_policy]
  bucket = module.ccc_insights_audio_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_unrefined_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ccc_callrecordings_bucket_encryption" {
  depends_on = [module.ccc_callrecordings_bucket.s3_ssl_policy]
  bucket = module.ccc_callrecordings_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_ccc_piimetadata_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Below Part added for S3-Presigned-URL
resource "aws_s3_bucket_acl" "ccc_insights_audio_bucket_acl" {
  depends_on = [ module.ccc_insights_audio_bucket.s3_bucket_id ]
  bucket = module.ccc_insights_audio_bucket.s3_bucket_id
  acl    = "log-delivery-write"  
}

# Below Part added for S3-Presigned-URL
resource "aws_s3_bucket_acl" "ccc_callaudioaccesslogs_bucket_acl" {
  depends_on = [ module.ccc_callaudioaccesslogs_bucket.s3_bucket_id ]
  bucket = module.ccc_callaudioaccesslogs_bucket.s3_bucket_id
  acl    = "log-delivery-write"  
}

 

resource "aws_s3_bucket_logging" "ccc_callaudioaccesslogs_bucket_logging" {
  bucket = module.ccc_insights_audio_bucket.s3_bucket_id
  target_bucket = module.ccc_callaudioaccesslogs_bucket.s3_bucket_id
  target_prefix = "log/"
}