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

# module "lambda_log_group" {
#   source = "app.terraform.io/SempraUtilities/seu-cloudwatch-log-group/aws"
#   retention_in_days = 7

#   company_code     = local.company_code
#   application_code = local.application_code
#   application_use  = local.application_use
#   environment_code = local.environment_code
#   region_code      = local.region_code

#   tags = merge(
#     local.tags,
#     {
#       name = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-generic-log-group"
#     },
#   )
# }