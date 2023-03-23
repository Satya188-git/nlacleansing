output "transcribe_lambda_role_arn" {
  description = "arn for the transcribe_lambda_role role"
  value       = module.transcribe_lambda_role.arn
}
output "comprehend_lambda_role_arn" {
  description = "arn for the comprehend_lambda_role role"
  value       = module.comprehend_lambda_role.arn
}
output "informational_macie_lambda_role_arn" {
  description = "arn for the informational_macie_lambda_role role"
  value       = module.informational_macie_lambda_role.arn
}
output "macie_lambda_role_arn" {
  description = "arn for the macie_lambda_role role"
  value       = module.macie_lambda_role.arn
}
output "trigger_macie_lambda_role_arn" {
  description = "arn for the trigger_macie_lambda_role role"
  value       = module.trigger_macie_lambda_role.arn
}
output "sns_lambda_role_arn" {
  description = "arn for the sns_lambda_role role"
  value       = module.sns_lambda_role.arn
}
output "athena_lambda_role_arn" {
  description = "arn for the athena_lambda_role role"
  value       = module.athena_lambda_role.arn
}
output "audit_call_lambda_role_arn" {
  description = "arn for the audit_call_lambda_role_arn role"
  value       = module.audit_call_lambda_role.arn
}
output "autoscaler_iam_role_id" {
  value = module.autoscaler_iam_role.id
}

output "custom_transcribe_lambda_role_arn" {
  value = module.custom_transcribe_lambda_role.arn
}
output "custom_transcribe_lambda_role_id" {
  value = module.custom_transcribe_lambda_role.id
}
