output "comprehend_lambda_arn" {
  description ="comprehend_data_trigger_arn"
  value       = module.ccc_comprehend_lambda.lambda_function_arn
}

output "ccc_transcribe_lambda_arn" {
  description = "ccc_transcribe_lambda_arn"
  value       = module.ccc_transcribe_lambda.lambda_function_arn
}

output "macie_info_trigger_arn" {
  description = "macie_info_trigger_arn"
  value       = module.ccc_informational_macie_lambda.lambda_function_arn
}

output "macie_scan_trigger_arn" {
  description = "macie_scan_trigger_arn"
  value       = module.ccc_macie_scan_trigger_lambda.lambda_function_arn
}

output "ccc_audit_call_lambda_arn" {
  description ="ccc_audit_call_lambda ARN"
  value       = module.ccc_audit_call_lambda.lambda_function_arn
}

output "ccc_audio_copy_lambda_arn" {
  description ="ccc_audio_copy_lambda ARN"
  value       = module.ccc_audio_copy_lambda.lambda_function_arn
}

output "ccc_audio_access_logs_to_cw_lambda_arn" {
  description ="ccc_audio_access_logs_to_cw_lambda ARN"
  value       = module.ccc_audio_access_logs_to_cw_lambda.lambda_function_arn
}

output "ccc_access_denied_notification_lambda_arn" {
  description ="ccc_access_denied_lambda ARN"
  value       = module.ccc_access_denied_notification_lambda.lambda_function_arn
}