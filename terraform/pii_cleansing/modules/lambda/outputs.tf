output "comprehend_lambda_arn" {
  description ="comprehend_data_trigger_arn"
  value       = module.ccc_comprehend_lambda.lambda_function_arn
}

output "unrefined_data_trigger_arn" {
  description = "unrefined_data_trigger_arn"
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

