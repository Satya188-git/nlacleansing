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
    "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    "sempra:gov:unit"   = var.unit				# unit                = var.unit
    portfolio           = var.portfolio
    support-group       = var.support-group
    "sempra:gov:environment" = var.environment 	# environment         = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
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
      }]
    }
   }
  }
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-transcription-rule"
    },
  )
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

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-unrefined-rule"
    },
  )
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

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-cleaned-rule"
    },
  )
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

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-cleaned-verified-rule"
    },
  )
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
    },
    "object": {
        "key": [{
          "suffix": ".gz"
        }]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-macie-info-rule"
    },
  )
}


resource "aws_cloudwatch_event_rule" "callrecordings_audio_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callrecordings-audio-rule"
  description   = "activate lambda when object is created into bucket callrecordings prefix EDIX_AUDIO"
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
        "${var.ccc_callrecordings_bucket_id}"
      ]
    },
    "object": {
        "key": [{
          "prefix": "EDIX_AUDIO/"
        }]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callrecordings-audio-rule"
    },
  )
}


resource "aws_cloudwatch_event_rule" "callrecordings_metadata_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callrecordings-metadata-rule"
  description   = "activate lambda when object is created into bucket callrecordings prefix EDIX_METADATA"
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
        "${var.ccc_callrecordings_bucket_id}"
      ]
    },
    "object": {
        "key": [{
          "prefix": "EDIX_METADATA/"
        }]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callrecordings-metadata-rule"
    },
  )
}


resource "aws_cloudwatch_event_rule" "pii_metadata_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-pii-metadata-rule"
  description   = "activate lambda when object is created into bucket piimetadata"
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
        "${var.ccc_piimetadata_bucket_id}"
      ]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-pii-metadata-rule"
    },
  )
}


resource "aws_cloudwatch_event_rule" "audio_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-audio-rule"
  description   = "activate lambda when object is created into bucket nla-audio"
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
        "${var.ccc_insights_audio_bucket_id}"
      ]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-audio-rule"
    },
  )
}

# Rule to trigger ccc_audio_access_logs_to_cw_lambda for S3 access logs generation
resource "aws_cloudwatch_event_rule" "ccc_audio_access_logs_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-audio-access-logs-s3-event-rule"
  description   = "activate ccc_audio_access_logs_to_cw_lambda when s3 access log object is created into bucket ccallaudioaccesslogs"
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
        "${var.ccc_nla_access_bucket_id}"
      ]
    },
    "object": {
        "key": [{
          "prefix": "callaudiolog/"
        }]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-audio-access-logs-s3-event-rule"
    },
  )
}

# Rule to send SNS notification for WFM Spervisor data is uploaded to Callrecordings S3 bucket
resource "aws_cloudwatch_event_rule" "callrecordings_supervisor_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callrecordings-supervisor-notification-rule"
  description   = "Sends SNS notification for WFM Spervisor data is uploaded to Callrecordings S3 bucket"
  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": [
        "${var.ccc_callrecordings_bucket_id}"
      ]
    },
    "object": {
      "key": [
		{"suffix": ".xlsx"},
        {"suffix": ".XSLX"}, 
		{"prefix": "EDIX_SUPERVISOR/"}
		]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callrecordings-supervisor-notification-rule"
    },
  )
}

resource "aws_cloudwatch_event_rule" "ccc_audio_copy_s3_event_rule" {
  name        = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-audio-copy-rule"
  description = "run lambda at 5 minute intervals"
  schedule_expression = "rate(5 minutes)"
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-audio-copy-rule"
    },
  ) 
}

resource "aws_cloudwatch_event_rule" "ccc_pii_maciescan_scheduler_rule" {
  name        = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-maciescan-scheduler-rule"
  description = "run lambda at 5 minute intervals"
  schedule_expression = "rate(5 minutes)"
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-pii-maciescan-scheduler-rule"
    },
  ) 
}

#Below rule is for access denied notification lambda
resource "aws_cloudwatch_event_rule" "ccc_access_denied_notification_logs_s3_event_rule" {
  name          = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-access-denied-event-rule"
  description   = "activate access-denied-notification-lambda when s3 access log object is created into bucket nla-access"
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
        "${var.ccc_nla_access_bucket_id}"
      ]
    },
    "object": {
      "key": [{
        "prefix": "callrecordinglogs/"
      }, {
        "prefix": "transcriptionlogs/"
      }, {
        "prefix": "callaudiologs/"
      }, {
        "prefix": "unrefinedlogs/"
      },{
        "prefix": "verifiedcleanedlogs/"
      },{
        "prefix": "dirtylogs/"
      }]
    }
  }
}
EOF

  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-ccc-access-denied-event-rule"
    },
  )
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

resource "aws_cloudwatch_event_target" "ccc_audio_copy_lambda_target" {
  arn       = var.ccc_audio_copy_lambda_arn
  rule      = aws_cloudwatch_event_rule.ccc_audio_copy_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "callrecordings_audio_lambda_target" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.callrecordings_audio_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "callrecordings_metadata_lambda_target" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.callrecordings_metadata_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "pii_metadata_lambda_target" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.pii_metadata_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "audio_lambda_target" {
  arn  = var.ccc_audit_call_lambda_arn
  rule = aws_cloudwatch_event_rule.audio_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "audio_access_logs_to_cw_lambda_target" {
  arn  = var.ccc_audio_access_logs_to_cw_lambda_arn
  rule = aws_cloudwatch_event_rule.ccc_audio_access_logs_s3_event_rule.name
}

resource "aws_cloudwatch_event_target" "customercallcenterpiimaciescan_lambda_target" {
  arn  = var.macie_scan_trigger_arn
  rule = aws_cloudwatch_event_rule.ccc_pii_maciescan_scheduler_rule.name
}

resource "aws_cloudwatch_event_target" "access_denied_notification_lambda_target" {
  arn  = var.ccc_access_denied_notification_lambda_arn
  rule = aws_cloudwatch_event_rule.ccc_access_denied_notification_logs_s3_event_rule.name
}

# select SNS target for eventbridge rule
resource "aws_cloudwatch_event_target" "callrecordings_supervisor_notification_rule_sns_target" {
 arn  = var.sns-supervisor-data-notification-topic-subscription-arn
 rule = aws_cloudwatch_event_rule.callrecordings_supervisor_s3_event_rule.name
 
 input_transformer {
     input_paths = {
        event      = "$.detail-type",
        time       = "$.time",
        bucketname = "$.detail.bucket.name",
        key        = "$.detail.object.key"
     }

     input_template = "\"Supervisor Data <event> At <time> On <bucketname>/<key>\""
    }  
}