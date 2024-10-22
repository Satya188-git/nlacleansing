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
    "sempra:gov:unit"   = var.unit 				# unit                = var.unit
    portfolio           = var.portfolio
    support-group       = var.support-group
    "sempra:gov:environment" = var.environment 	# environment         = var.environment
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
  }
}

module "callaudioaccess_log_group" {
  source = "app.terraform.io/SempraUtilities/seu-cloudwatch-log-group/aws"
  retention_in_days = 0
  version = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  application_use  = "${local.application_use}-callaudioaccess"
  environment_code = local.environment_code
  region_code      = local.region_code

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-callaudioaccess-log-group"
    },
  )
}

resource "aws_cloudwatch_log_stream" "callaudioaccess_log_group" {
  name           = "logstream"
  log_group_name = module.callaudioaccess_log_group.cloudwatch_log_group_name
}

resource "aws_cloudwatch_log_metric_filter" "callaudioaccess-metrics" {
  name           = "Pre-signed-url-access"
  pattern        = "REST.GET.OBJECT"
  log_group_name = module.callaudioaccess_log_group.cloudwatch_log_group_name

  metric_transformation {
      name      = "GetAudio"
      namespace = "AudioAccessMetrics"
      value     = "1"
      unit 	    = "Count"
  }
}

module "nla_audio_access_alarm" {
  depends_on = [aws_cloudwatch_log_metric_filter.callaudioaccess-metrics]
  source  = "app.terraform.io/SempraUtilities/seu-cloudwatch-alarms/aws"
  version = "10.0.0"
  company_code     = local.company_code
  application_code = local.application_code
  application_use  = "${local.application_use}-callaudioaccess"
  environment_code = local.environment_code
  region_code      = local.region_code

  tags = merge(
    local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-audio-access-alarm"
    },
  )

  alarm_description   = "Detected multiple call audios accessed/played"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "GetAudio"
  alarm_namespace     = "AudioAccessMetrics"
  period_in_seconds   = "300"
  statistic           = "Sum"
  threshold           = "9"
  alarm_actions       = [var.sns-topic-arn]
}