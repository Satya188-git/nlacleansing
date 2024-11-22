output "sqs_historical_etl_output_arn" {
  description = "SQS supervisor dataloader queue arn"
  value       = module.sqs_historical_etl_output.arn
}

output "sqs_historical_etl_output_id" {
  description = "SQS supervisor dataloader queue id"
  value       = module.sqs_historical_etl_output.id
}