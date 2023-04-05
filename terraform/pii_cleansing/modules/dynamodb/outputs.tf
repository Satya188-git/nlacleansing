output "dynamodb_audit_table_arn" {
  description = "Dynamo DB audit table arn"
  value       = module.dynamodb_audit_table.table_arn
}
output "dynamodb_audit_table_name" {
  value = module.dynamodb_audit_table.table_id
}
