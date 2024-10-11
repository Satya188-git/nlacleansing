output "nla_replication_role_arn" {
  description = "arn for the nla_replication_role"
  value       = module.nla_replication_role.arn
}

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

output "athena_crawler_role_id" {
  value = module.athena_crawler_role.id
}

output "athena_crawler_role_arn" {
  value = module.athena_crawler_role.arn
}

output "audio_copy_lambda_role_arn" {
  value = module.audio_copy_role.arn
}

output "file_transfer_lambda_role_arn" {
  value = module.file_transfer_lambda_role.arn
}

output "ccc_audio_access_logs_to_cw_lambda_role_arn" {
  description = "ccc_audio_access_logs_to_cw_lambda_role arn"
  value       = module.ccc_audio_access_logs_to_cw_lambda_role.arn
}

output "insights_assumed_role_arn" {
  description = "insights_assumed_role arn"
  value       = module.insights_assumed_role.arn
}

output "ccc_access_denied_notification_lambda_role_arn" {
  description = "ccc_access_denied_notification_lambda_role arn"
  value       = module.ccc_access_denied_notification_lambda_role.arn
}