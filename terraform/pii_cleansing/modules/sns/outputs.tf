output "sns-topic-arn" {
  value       = module.sns.email_subscription_arn
  description = "ARN for SNS topic's email subscription"
}

output "sns-supervisor-data-notification-topic-subscription-arn" {
 value       = module.supervisor-data-notification-sns.email_subscription_arn
 description = "ARN for supervisor-data-notification-sns topic's email subscription"
}

output "access-denied-topic-arn" {
  value       = module.access-denied-notification-sns.email_subscription_arn
  description = "ARN for access-denied-ana topic's email subscription"
}

output "access_denied_notification_topic_arn" {
  value       = module.access_denied_notification_sns.sns_topic_arn
  description = "ARN for access-denied-ana topic's email subscription"
}