module "sns" {
  source           = "app.terraform.io/SempraUtilities/seu-sns/aws"
  version          = "4.0.6-prerelease"
  application_use  = "${var.application_use}-audio-access-notifications-topic"
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code

  tags = {
    name                = "${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-sns-nla-audio-access-notifications-topic"
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }

  name                  = "${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-sns-nla-audio-access-notifications-topic"
  kms_master_key_id     = var.sns_kms_key_id
  create_email_topic    = true # Must be set to true to enable email subscriptions
  email_subscriber_list = ["${var.audioaccessnotificationemail}"]
}

module "supervisor-data-notifications-sns" {
  source           = "app.terraform.io/SempraUtilities/seu-sns/aws"
  version          = "4.0.6-prerelease"
  application_use  = "${var.application_use}-supervisor-data-notification-topic"
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code

  tags = {
    name                = "${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-sns-nla-supervisor-data-notification-topic"
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    portfolio           = var.portfolio
    support-group       = var.support-group
    environment         = var.environment
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }

  name                  = "${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-sns-nla-supervisor-data-notification-topic"
  kms_master_key_id     = var.sns_kms_key_id
  create_email_topic    = true # Must be set to true to enable email subscriptions
  email_subscriber_list = ["${var.supervisordatanotificationemail}"]

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "supervisor_data_email_notification_policy",
  "Statement": [
    {
      "Sid": "EventBridgePublishNotification",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:${var.region}:${var.account_id}:${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-sns-nla-supervisor-data-notification-topic"
    }
  ]
}
EOF
}

resource "aws_sns_topic_subscription" "supervisor_email_subscription" {
  depends_on = [ module.supervisor-data-notifications-sns.sns_topic_arn ]
  topic_arn = "arn:aws:sns:${var.region}:${var.account_id}:${var.company_code}-${var.application_code}-${var.environment_code}-${var.region_code}-sns-nla-supervisor-data-notification-topic"
  protocol  = "email"
  endpoint  = var.supervisordatanotificationemail
}