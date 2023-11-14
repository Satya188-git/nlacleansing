locals {
  application_use                   = "${var.application_use}-s3-crawler"
  region                            = var.region
  aws_region                        = var.region
  company_code                      = var.company_code
  application_code                  = var.application_code
  environment_code                  = var.environment_code
  region_code                       = var.region_code
  namespace                         = var.namespace
  owner                             = var.owner
  glue_catalog_database_description = "nla glue athena db"
  glue_catalog_table_description    = "nla glue table"
  glue_catalog_table_table_type     = "EXTERNAL_TABLE"

  tags = {
    name                = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-s3-crawler-pii"
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
  version = "4.0.3"

  depends_on       = [var.athena_crawler_role_arn]
  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = local.application_use

  iam_role_arn  = var.athena_crawler_role_arn
  iam_role_name = var.athena_crawler_role_id

  glue_crawler_map = {
    crawler_s3 = {
      name          = "pii"
      database_name = var.athena_database_name
      s3_targets = {
        s3_target1 = {
          path = "s3://${var.ccc_piimetadata_bucket_id}/EDIX_METADATA/"
        }
      }
      dynamodb_targets = {}
      jdbc_targets     = {}
      catalog_targets  = {}
      mongodb_targets  = {}
      optional_arguments = {
        description            = var.crawler_description
        recrawl_policy         = "CRAWL_EVERYTHING"
        schema_delete_behavior = "DEPRECATE_IN_DATABASE"
        schema_update_behavior = "UPDATE_IN_DATABASE"
      }
    }
  }
  tags = local.tags
}

module "nla_glue_table" {
  version     = "4.1.1"
  source           = "app.terraform.io/SempraUtilities/seu-glue-data-catalog/aws"
  company_code     = local.company_code
  application_code = local.application_code
  application_use  = local.application_use
  environment_code = local.environment_code
  region_code      = local.region_code
  tags             = local.tags
  # glue catalog database
  glue_database_name = var.athena_database_name
  encrypt            = true
  # glue catalog tables 
  glue_catalog_map = {
    "${local.company_code}_${local.application_code}_${local.environment_code}_${local.region_code}_glue_nla_s3_crawler_pii_metadata" = {
      name                           = "${local.company_code}_${local.application_code}_${local.environment_code}_${local.region_code}_glue_nla_s3_crawler_pii_metadata"
      glue_catalog_table_description = local.glue_catalog_table_description
      glue_catalog_table_table_type  = local.glue_catalog_table_table_type
      glue_catalog_table_parameters = {
        "skip.header.line.count" = 1
        "sizeKey"                = 3487703
        "objectCount"            = 62
        "UPDATED_BY_CRAWLER"     = "${local.company_code}-${local.application_code}-${local.environment_code}-${local.region_code}-glue-nla-s3-crawler-pii"
        "recordCount"            = 10389
        "averageRecordSize"      = 333
        "compressionType"        = "none"
        "classification"         = "csv"
        "columnsOrdered"         = true
        "areColumnsQuoted"       = false
        "delimiter"              = ","
        "typeOfData"             = "file"
      }

      location                  = "s3://${var.ccc_piimetadata_bucket_id}/EDIX_METADATA/"
      input_format              = "org.apache.hadoop.mapred.TextInputFormat"
      output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      compressed                = false
      stored_as_sub_directories = "false"
      storage_descriptor_columns = [
        {
          columns_name = "path"
          columns_type = "string"
        },
        {
          columns_name = "file name"
          columns_type = "string"
        },
        {
          columns_name = "status"
          columns_type = "bigint"
        },
        {
          columns_name = "segment id"
          columns_type = "bigint"
        },
        {
          columns_name = "segment start time"
          columns_type = "string"
        },
        {
          columns_name = "segment stop time"
          columns_type = "string"
        },
        {
          columns_name = "internal segment client start time"
          columns_type = "string"
        },
        {
          columns_name = "internal segment client stop time"
          columns_type = "string"
        },
        {
          columns_name = "participant station"
          columns_type = "bigint"
        },
        {
          columns_name = "segment ucid"
          columns_type = "bigint"
        },
        {
          columns_name = "participant trunk group"
          columns_type = "bigint"
        },
        {
          columns_name = "participant trunk number"
          columns_type = "bigint"
        },
        {
          columns_name = "segment dialed number"
          columns_type = "bigint"
        },
        {
          columns_name = "participant phone-number"
          columns_type = "string"
        },
        {
          columns_name = "segment call direction type id"
          columns_type = "string"
        },
        {
          columns_name = "participant agent id"
          columns_type = "bigint"
        },
        {
          columns_name = "full name"
          columns_type = "string"
        },
        {
          columns_name = "segment vector number"
          columns_type = "bigint"
        },
      ]

      storage_descriptor_ser_de_info = [
        {
          ser_de_info_serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
          ser_de_info_parameters            = tomap({ "field.delim" = "," })
        },
      ]
    }
  }
}
