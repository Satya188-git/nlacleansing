local {
  application_use  = "nla"
  region           = "us-west-2"
  namespace        = "internal.aws"
  company_code     = "sdge"
  application_code = "dwcko"
  environment_code = "sbx"
  region_code      = "wus2"
  owner            = "IAC Team"
  tags = {
    tag-version         = "Holds the version of the tagging format."
    billing-guid        = "Internal order - from SAP"
    unit                = "Organizational unit"
    portfolio           = "Portfolio associated with the application"
    support-group       = "Distribution list in email format"
    environment         = "Environment deployed"
    cmdb-ci-id          = "CI ID as generated by ServiceNow CMDB"
    data-classification = "Data privacy classification"
  }
}

  module "dynamodb_audit_table" {
  region           = local.region
  region_code      = local.region_code
  source           = "app.terraform.io/SempraUtilities/seu-dynamodb/aws"
  table_name       = "ccc-call-audit-dev"
  hash_key         = "UUID"
  range_key        = "DateTimeStamp"
  enable_autoscaler         = true
  company_code     = local.company_code
  application_code = local.application_code
  application_use  = local.application_use
  environment_code = local.environment_code
  autoscaler_iam_role_id    = var.autoscaler_iam_role_id
  read_capacity = var.read_capacity
  write_capacity = var.write_capacity
  

  autoscaling_read = {
    "max_capacity" : 5,
    "min_capacity" : 1
  }
  autoscaling_write = {
    "max_capacity" : 5,
    "min_capacity" : 1
  }

  tags = merge(
    local.tags,
    {
      name = "DynamoDb audit table"
    },
  )
}
