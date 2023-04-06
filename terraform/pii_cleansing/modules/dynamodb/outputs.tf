output "dynamodb_audit_table_arn" {
  description = "Dynamo DB audit table arn"
  value       = module.dynamodb_audit_table.table_arn
}

output "dynamodb_audit_table_name" {
  description = "Dynamo DB audit table name"
  value       = module.dynamodb_audit_table.table_name
}
