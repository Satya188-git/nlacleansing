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

resource "aws_cloudwatch_event_rule" "customercallcenterpiitranscription_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-transcription-rule"
  description   = "activate lambda when object is created into bucket pii-transcription"
  event_pattern = <<EOF
  {
    "detail-type": [
      "Object Created"
    ],
    "source": [
      "aws.s3"
    ],
    "detail": {
      "bucket": {
        "name": ["${var.ccc_initial_bucket_id}"]
      },
    "object": {
      "key": [{
        "prefix": "standard/NLA"
      },
      { 
        "prefix": "standard_full_transcripts/NLA"
      }]
    }
   }
  }
EOF

  tags = local.tags
}

resource "aws_cloudwatch_event_rule" "customercallcenterpiiunrefined_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-unrefined-rule"
  description   = "activate lambda when object is created into bucket unrefined"
  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "Object Created"
  ],
  "detail": {
    "bucket": {
      "name": [
        "${var.ccc_unrefined_call_data_bucket_id}"
      ]
    }
  }
}
EOF

  tags = local.tags
}

resource "aws_cloudwatch_event_rule" "customercallcenterpiicleaned_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-cleaned-rule"
  description   = "activate lambda when object is created into bucket cleaned"
  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "Object Created"
  ],
  "detail": {
    "bucket": {
      "name": [
        "${var.ccc_cleaned_bucket_id}"
      ]
    }
  }
}
EOF

  tags = local.tags
}

resource "aws_cloudwatch_event_rule" "customercallcenterpiicleanedverified_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-cleaned-verified-rule"
  description   = "activate lambda when object is created into bucket verified-clean"
  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "Object Created"
  ],
  "detail": {
    "bucket": {
      "name": [
        "${var.ccc_verified_clean_bucket_id}"
      ]
    }
  }
}
EOF

  tags = local.tags
}

resource "aws_cloudwatch_event_rule" "customercallcenterpiimaciescan_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-maciescan-rule"
  description   = "activate lambda when object is created into bucket cleaned"
  event_pattern = <<EOF
  {
    "detail-type": [
      "Object Created"
    ],
    "source": [
      "aws.s3"
    ],
    "detail": {
      "bucket": {
        "name": ["${var.ccc_cleaned_bucket_id}"]
      },
    "object": {
      "key": [{
        "prefix": "standard_full_transcripts/"
      }]
    }
   }
  }
EOF

  tags = local.tags
}


resource "aws_cloudwatch_event_rule" "customercallcenterpiimacieinfo_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-macie-info-rule"
  description   = "activate lambda when object is created into bucket macie-findings"
  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "Object Created"
  ],
  "detail": {
    "bucket": {
      "name": [
        "${var.ccc_maciefindings_bucket_id}"
      ]
    }
  }
}
EOF

  tags = local.tags
}




# select lambda target for eventbridge rule
resource "aws_cloudwatch_event_target" "customercallcenterpiitranscription_lambda_target1" {
  arn  = var.comprehend_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiitranscription_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiitranscription_lambda_target2" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiitranscription_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiiunrefined_lambda_target1" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiiunrefined_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiiunrefined_lambda_target2" {
  arn  = var.ccc_transcribe_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiiunrefined_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiicleanedverified_lambda_target" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiicleanedverified_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiicleaned_lambda_target" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiicleaned_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiimacieinfo_lambda_target" {
  arn  = var.macie_info_trigger_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiimacieinfo_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiimaciescan_lambda_target" {
  arn  = var.macie_scan_trigger_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiimaciescan_s3_event_rule.name
}

# module "eventbridge" {
#   source = "terraform-aws-modules/eventbridge/aws"

#   bus_name = "insert-bus"

#   rules = {
#     orders = {
#       description = "Object creation for call metadata in final_output s3 trigger event rule"
#       event_pattern = jsonencode({
#         "source" : ["aws.s3"],
#         "detail-type" : ["Object Created"],
#         "detail" : {
#           "bucket" : {
#             "name" : ["${var.replicated_clean_data_bucket_id}"]
#           },
#           "object" : {
#             "key" : [{
#               "prefix" : "final_insights"
#             }]
#           }
#         }
#       })
#       enabled = true
#     }
#   }

#   targets = {
#     orders = [
#       {
#         name = "${var.call_data_insert_lambda_name}"
#         arn  = var.call_data_insert_lambda_arn
#       }
#     ]
#   }
# }
