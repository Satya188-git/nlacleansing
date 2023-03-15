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

  module "dynamodb_audit_table" {
  region           = local.region
  region_code      = local.region_code
  source           = "app.terraform.io/SempraUtilities/seu-dynamodb/aws"
  table_name       = "ccc-call-audit-${var.environment_code}"
  hash_key         = "UUID"
  range_key        = "DateTimeStamp"
  dynamodb_attributes= [
    {
      name="UUID"
      type="S"
    },
    {
      name="CallType"
      type="S"
    },
    {
      name="CallID"
      type="S"
    },
    {
      name="Path"
      type="S"
    },
    {
      name="FileName"
      type=""
    },
    {
      name="Status"
      type="S"
    },
    {
      name="DateTimeStamp"
      type="S"
    }
  ]

  local_secondary_index_map    = [
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

 module "dynamodb_metadata_table" {
  region           = local.region
  region_code      = local.region_code
  source           = "app.terraform.io/SempraUtilities/seu-dynamodb/aws"
  table_name       = "ccc-call-metadata-${var.environment_code}"
  hash_key         = "fileID"
  range_key        = "internalSegmentClientStartTime"
  dynamodb_attributes= [
    {
      name="companyName"
      type="S"
    },
    {
      name="fileName"
      type="N"
    },
    {
      name="fullName"
      type="S"
    },
    {
      name="participantPhoneNumber"
      type="S"
    },
    {
      name="participantAreaCode"
      type="S"
    },
    {
      name="segmentID"
      type="S"
    },
    {
      name="segmentDialedNumber"
      type="S"
    },
    {
      name="segmentStartTime"
      type="S"
    },
    {
      name="segmentStopTime"
      type="S"
    },
    {
      name="segmentVectorNumber"
      type="S"
    },
    {
      name="internalSegmentClientStartTime"
      type="S"
    },
    {
      name="internalSegmentClientStartTime"
      type="S"
    },
    {
      name="language"
      type="N"
    },
    {
      name="customerType"
      type="S"
    },
    {
      name="ivrCallcategory"
      type="S"
    },
    {
      name="batchName"
      type="S"
    }
  ]
  local_secondary_index_map    = [
    {
      name               = "participantAgentId"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "participantAgentId"

    },
    {
      name               = "internalSegmentClientStopTime"
      non_key_attributes = []
      projection_type    = "ALL"
      range_key          = "internalSegmentClientStopTime"

    },
  ]

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
