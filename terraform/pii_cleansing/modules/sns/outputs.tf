output "sns-topic-arn" {
  value       = module.sns.email_subscription_arn
  description = "ARN for SNS topic"
}

output "sns-supervisor-data-notifications-topic-arn" {
  value       = module.supervisor-data-notifications-sns.email_subscription_arn
  description = "ARN for supervisor-data-notifications-sns topic"
}