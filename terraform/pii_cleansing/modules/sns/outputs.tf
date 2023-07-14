output "sns-topic-arn" {
  value       = module.sns.email_subscription_arn
  description = "ARN for SNS topic"
}
