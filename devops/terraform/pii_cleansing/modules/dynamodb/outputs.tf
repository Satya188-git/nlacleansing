output "dynamodb_audit_table_arn" {
  description = "Dynamo DB audit table arn"
  value       = module.dynamodb_metadata_table.table_arn
}

output "dynamodb_metadata_table_arn" {
  description = "Dynamo DB metadata table arn"
  value       = module.dynamodb_metadata_table.table_arn
}
