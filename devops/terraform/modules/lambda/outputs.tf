# comprehend_data_trigger ccc_initial_bucket_arn ccc_comprehend_lambda
output "comprehend_data_trigger_arn" {
  description ="comprehend_data_trigger_arn"
  value       = module.ccc_comprehend_lambda.lambda_function_arn
}

# unrefined_data_trigger ccc_unrefined_call_data_bucket_arn ccc_transcribe_lambda
output "unrefined_data_trigger_arn" {
  description = "unrefined_data_trigger_arn"
  value       = module.ccc_transcribe_lambda.lambda_function_arn
}


# macie_info_trigger ccc_maciefindings_bucket_arn
output "macie_info_trigger_arn" {
  description = "macie_info_trigger_arn"
  value       = module.ccc_informational_macie_lambda.lambda_function_arn
}

# macie_scan_trigger ccc_cleaned_bucket_arn
output "macie_scan_trigger_arn" {
  description = "macie_scan_trigger_arn"
  value       = module.ccc_macie_scan_trigger_lambda.lambda_function_arn
}

