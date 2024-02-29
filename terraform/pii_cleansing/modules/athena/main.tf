locals {
  region           = var.region
  aws_region       = var.region
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  namespace        = var.namespace
  owner            = var.owner
  tags = {
    # "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
    billing-guid        = var.billing-guid
    "sempra:gov:unit"   = var.unit 				# unit                = var.unit
    support-group       = var.support-group
    "sempra:gov:environment" = var.environment 	# environment         = var.environment_code
    "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
    data-classification = var.data-classification
    portfolio           = var.portfolio

  }
}

module "athena" {
  depends_on       = [var.ccc_athenaresults_bucket_id]
  source           = "app.terraform.io/SempraUtilities/seu-athena/aws"
  version          = "10.0.1"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "nla-pii"
  tags = merge(local.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-pii-athena"
    },
  )

  # option to create Athena workgroup and corresponding variables
  create_workgroup                   = true
  workgroup_force_destroy            = true
  workgroup_description              = "Athena NLA Workgroup"
  enforce_workgroup_configuration    = true
  publish_cloudwatch_metrics_enabled = true
  output_location                    = "s3://${var.ccc_athenaresults_bucket_id}/"
  workgroup_encryption_option        = "SSE_KMS"
  workgroup_kms_key_arn              = var.athena_kms_key_arn

  # option to create Athena DB and corresponding variables
  create_athena_database    = true
  db_force_destroy          = true
  athena_db_name            = "${local.company_code}_${local.application_code}_${local.environment_code}_${local.region_code}_nla_athena_db"
  athena_database_bucket    = var.ccc_athenaresults_bucket_id
  db_encryption_option      = "SSE_KMS"
  db_kms_key_arn            = var.athena_kms_key_arn
  create_athena_named_query = false
}
