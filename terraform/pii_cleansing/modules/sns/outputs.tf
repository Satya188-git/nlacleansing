output "sns-topic-arn" {
  value       = module.sns.email_subscription_arn
  description = "ARN for SNS topic's email subscription"
}

output "sns-supervisor-data-notification-topic-subscription-arn" {
 value       = module.supervisor-data-notification-sns.email_subscription_arn
 description = "ARN for supervisor-data-notification-sns topic's email subscription"
}