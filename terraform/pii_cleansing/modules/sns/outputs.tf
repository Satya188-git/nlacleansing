output "sns-topic-arn" {
  value       = module.sns.email_subscription_arn
  description = "ARN for SNS topic's email subscription"
}

output "sns-supervisor-data-notifications-topic-subscription-arn" {
 value       = module.supervisor-data-notifications-sns.email_subscription_arn
 description = "ARN for supervisor-data-notifications-sns topic's email subscription"
}