output "sns_topic_arn" {
  value       = module.sns.email_subscription_arn
  description = "ARN for SNS topic"
}
