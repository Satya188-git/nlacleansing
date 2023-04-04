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
  name = "profile-generator-lambda-event-rule"
  description = "activate lambda when object is created into bucket pii-transcription"
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
}

# select lambda target for eventbridge rule
resource "aws_cloudwatch_event_target" "customercallcenterpiitranscription_lambda_target" {
  arn = var.comprehend_lambda_arn
  rule = aws_cloudwatch_event_rule.customercallcenterpiitranscription_s3_event_rule.name
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
