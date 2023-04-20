output "nla_glue_table_name" {
  description = "nla_glue_table_name"
  value       = module.nla_glue_table.glue_catalog_table_name

}

output "nla_glue_database_name" {
  description = "nla_glue_database_name"
  value       = module.nla_glue_table.glue_catalog_database_name

}
