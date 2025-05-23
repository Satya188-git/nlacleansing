locals {
  application_use  = var.application_use
  region           = var.region
  namespace        = var.namespace
  company_code     = var.company_code
  application_code = var.application_code
  environment_code = var.environment_code
  region_code      = var.region_code
  owner            = var.owner
  # tags = {
  #   "sempra:gov:tag-version" = var.tag-version  # tag-version         = var.tag-version
  #   billing-guid        = var.billing-guid
  #   "sempra:gov:unit"   = var.unit 				# unit                = var.unit
  #   portfolio           = var.portfolio
  #   support-group       = var.support-group
  #   "sempra:gov:environment" = var.environment 	# environment         = var.environment
  #   "sempra:gov:cmdb-ci-id"  = var.cmdb-ci-id 	# cmdb-ci-id          = var.cmdb-ci-id
  #   data-classification = var.data-classification
  # }
}
/*module "dynamodb_audit_table" {
  version     = "10.1.0"
  region      = local.region
  region_code = local.region_code
  source      = "app.terraform.io/SempraUtilities/seu-dynamodb/aws"
  table_name  = "ccc-call-audit"
  hash_key    = "UUID"
  range_key   = "DateTimeStamp"
  dynamodb_attributes = [
    {
      name = "UUID"
      type = "S"
    },
    {
      name = "CallType"
      type = "S"
    },
    {
      name = "CallID"
      type = "S"
    },
    {
      name = "FileName"
      type = "S"
    },
    {
      name = "DateTimeStamp"
      type = "S"
    }
  ]

  local_secondary_index_map = [
    {
      name               = "CallType"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "CallType"

    },
    {
      name               = "CallID"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "CallID"

    },
    {
      name               = "FileName"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "FileName"

    }
  ]
  enable_autoscaler      = true
  company_code           = local.company_code
  application_code       = local.application_code
  application_use        = local.application_use
  environment_code       = local.environment_code
  autoscaler_iam_role_id = var.autoscaler_iam_role_id
  read_capacity          = var.read_capacity
  write_capacity         = var.write_capacity


  autoscaling_read = {
    "max_capacity" : 5,
    "min_capacity" : 1
  }
  autoscaling_write = {
    "max_capacity" : 5,
    "min_capacity" : 1
  }

  tags = merge(
    data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-dynamodb-audit-table"
    },
  )  
}*/

data "aws_default_tags" "aws_tags" {}

module "dynamodb_nla_audit_table" {
  version     = "10.1.0"
  region      = local.region
  region_code = local.region_code
  source      = "app.terraform.io/SempraUtilities/seu-dynamodb/aws"
  table_name  = "ccc-call-processing-audit"
  hash_key    = "callType"
  range_key   = "datetimeStamp"
  hash_key_type = "N"
  range_key_type = "N"
  dynamodb_attributes = [
    {
      name = "callId"
      type = "N"
    },
    {
      name = "fileName"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    }
  ]

  local_secondary_index_map = [
    {
      name               = "callId-index"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "callId"

    },
    {
      name               = "fileName-index"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "fileName"

    },
    {
      name               = "status-index"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "status"

    }
  ]
  #enable_autoscaler      = true
  company_code           = local.company_code
  application_code       = local.application_code
  application_use        = local.application_use
  environment_code       = local.environment_code
  #autoscaler_iam_role_id = var.autoscaler_iam_role_id
  #read_capacity          = var.read_capacity
  #write_capacity         = var.write_capacity
  billing_mode = "PAY_PER_REQUEST"

  #autoscaling_read = {
  #  "max_capacity" : 5,
  #  "min_capacity" : 1
  #}
  #autoscaling_write = {
  #  "max_capacity" : 5,
  #  "min_capacity" : 1
  #}

  tags = merge(
    data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-dynamodb-nla-audit-table"
    },
  ) 
}


module "dynamodb_calltype_table" {
  version     = "10.1.0"
  region      = local.region
  region_code = local.region_code
  source      = "app.terraform.io/SempraUtilities/seu-dynamodb/aws"
  table_name  = "ccc-call-type"
  hash_key    = "callType"
  range_key   = "createdDate"
  hash_key_type = "N"
  range_key_type = "N"
  dynamodb_attributes = [
    {
      name = "callCategory"
      type = "S"
    }
  ]

  global_secondary_index_map = [
    { 
      name               = "callCategory-createdDate-index"
      hash_key           = "callCategory"
      range_key          = "createdDate"
      non_key_attributes = []
      projection_type    = "ALL"
      read_capacity          = var.read_capacity
      write_capacity         = var.write_capacity  
      enable_autoscaler      = true 
      autoscaler_iam_role_id = var.autoscaler_iam_role_id      
    }
  ]  
  
  enable_autoscaler      = true
  company_code           = local.company_code
  application_code       = local.application_code
  application_use        = local.application_use
  environment_code       = local.environment_code
  autoscaler_iam_role_id = var.autoscaler_iam_role_id
  read_capacity          = var.read_capacity
  write_capacity         = var.write_capacity


  autoscaling_read = {
    "max_capacity" : 5,
    "min_capacity" : 1
  }
  autoscaling_write = {
    "max_capacity" : 5,
    "min_capacity" : 1
  }

  tags = merge(
    data.aws_default_tags.aws_tags.tags,
    {
      "sempra:gov:name" = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-dynamodb-calltype-table"
    },
  )
}