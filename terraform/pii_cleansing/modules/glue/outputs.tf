output "nla_glue_table_name" {
  description = "nla_glue_table_name"
  value       = module.nla_glue_table.glue_catalog_table_name
}

output "nla_glue_database_name" {
  description = "nla_glue_database_name"
  value       = module.nla_glue_table.glue_catalog_database_name
}

output "historicals_calls_etl_job" {
  description = "ELT job for historical calls"
  value       = module.historicals_calls_etl_job.glue_job_name
}