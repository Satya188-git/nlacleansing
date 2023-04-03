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
    name                = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-nla-athena"
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


# // create IAM role for crawler
# module "athena_crawler_role" {
#   source  = "app.terraform.io/SempraUtilities/seu-iam-role/aws"
#   version = "x.x.x"

#   company_code      = local.company_code
#   application_code  = local.application_code
#   environment_code  = local.environment_code
#   region_code       = local.region_code
#   application_use   = "glue-crawler-test"
#   description       = "Test IAM role for Athena"
#   service_resources = ["glue.amazonaws.com"]

#   tags = local.tags
# }

# // create policy
# resource "aws_iam_policy" "policy" {
#   name        = "AthenaBucketAccess"
#   description = "Get and Put access for Athena bucket"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:GetObject",
#         "s3:PutObject"
#       ],
#       "Effect": "Allow",
#       "Resource": "${var.ccc_athenaresults_bucket_arn}*"
#     }
#   ]
# }
# EOF
# }

# // attach policy for role
# resource "aws_iam_policy_attachment" "attach-custom" {
#   name       = "athena-test-attachment"
#   roles      = [module.athena_crawler_role.id]
#   policy_arn = aws_iam_policy.policy.arn
# }

# resource "aws_iam_role_policy_attachment" "attach-managed-glue" {
#   role       = module.athena_crawler_role.id
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
# }

# // create kms key to encrypt athena data
# resource "aws_kms_key" "athena_kms_key" {
#   deletion_window_in_days = 7
#   description             = "Athena KMS Key"
#   enable_key_rotation     = true
# }

module "athena" {
  source           = "app.terraform.io/SempraUtilities/seu-athena/aws"
  version          = "7.1.0"
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "athena-nla"
  tags             = local.tags

  # option to create Athena workgroup and corresponding variables
  create_workgroup                   = true
  workgroup_force_destroy            = true
  workgroup_description              = "Athena NLA Workgroup"
  enforce_workgroup_configuration    = true
  publish_cloudwatch_metrics_enabled = true
  output_location                    = "s3://${var.ccc_athenaresults_bucket_id}/output/"
  workgroup_encryption_option        = "SSE_KMS"
  workgroup_kms_key_arn              = var.athena_kms_key_arn

  # option to create Athena DB and corresponding variables
  create_athena_database    = true
  db_force_destroy          = false
  athena_db_name            = "${local.company_code}_${local.application_code}_${local.environment_code}_${local.region_code}_nla_athena_db"
  athena_database_bucket    = var.ccc_athenaresults_bucket_id
  db_encryption_option      = "SSE_KMS"
  db_kms_key_arn            = var.athena_kms_key_arn
  create_athena_named_query = false
}


