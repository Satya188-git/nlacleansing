output "dynamodb_audit_table_arn" {
  description = "Dynamo DB audit table arn"
  value       = module.dynamodb_audit_table.table_arn
}
