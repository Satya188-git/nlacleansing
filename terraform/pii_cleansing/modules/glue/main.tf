locals {
  application_use  = "${var.application_use}-s3-crawler"
  region           = var.region
  aws_region       = var.region
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  namespace        = var.namespace
  owner            = var.owner

  tags = {
    name                = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-s3-crawler"
    tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    unit                = var.unit
    support-group       = var.support-group
    environment_code    = var.environment_code
    cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
    portfolio           = var.portfolio
    environment         = var.environment_code
  }
}


module "glue-crawler" {
  source  = "app.terraform.io/SempraUtilities/seu-glue-crawler/aws"
  version = "4.0.2"

  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = local.application_use

  iam_role_arn  = var.athena_crawler_role_arn
  iam_role_name = var.athena_crawler_role_id

  glue_crawler_map = {
    crawler_s3 = {
      name          = "s3_crawler"
      database_name = var.crawler_db_name
      s3_targets = {
        s3_target1 = {
          path = "s3://${var.ccc_athenaresults_bucket_id}/test_data/"
        }
      }
      dynamodb_targets = {}
      jdbc_targets     = {}
      catalog_targets  = {}
      mongodb_targets  = {}
      optional_arguments = {
        description            = var.crawler_description
        recrawl_policy         = "CRAWL_EVERYTHING"
        schema_delete_behavior = "LOG"
        schema_update_behavior = "LOG"
      }
    }
  }
  tags = local.tags
}