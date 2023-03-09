output "initiator_lambda_invoke-arn" {
  description ="initiator_lambda_invoke-arn"
  value       = module.initiator_lambda.lambda_function_arn
}

output "post_lambda_invoke-arn" {
  description = "ocr_post_process_lambda lambda function"
  value       = module.ocr_post_process_lambda.lambda_function_arn
}