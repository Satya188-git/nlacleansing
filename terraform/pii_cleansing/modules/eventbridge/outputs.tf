output "customercallcenterpiitranscription_s3_event_rule_arn" {
  description = "comprehend_data_trigger_arn"
  value       = aws_cloudwatch_event_rule.customercallcenterpiitranscription_s3_event_rule.arn
}

output "customercallcenterpiicleanedverified_s3_event_rule_arn" {
  description = "customercallcenterpiicleanedverified_s3_event_rule_arn"
  value       = aws_cloudwatch_event_rule.customercallcenterpiicleanedverified_s3_event_rule.arn
}

output "customercallcenterpiiunrefined_s3_event_rule_arn" {
  description = "customercallcenterpiiunrefined_s3_event_rule_arn"
  value       = aws_cloudwatch_event_rule.customercallcenterpiiunrefined_s3_event_rule.arn
}

output "customercallcenterpiicleaned_s3_event_rule_arn" {
  description = "customercallcenterpiicleaned_s3_event_rule_arn"
  value       = aws_cloudwatch_event_rule.customercallcenterpiicleaned_s3_event_rule.arn
}

output "customercallcenterpiimacieinfo_s3_event_rule_arn" {
  description = "customercallcenterpiimacieinfo_s3_event_rule_arn"
  value       = aws_cloudwatch_event_rule.customercallcenterpiimacieinfo_s3_event_rule.arn
}

output "customercallcenterpiimaciescan_s3_event_rule_arn" {
  description = "customercallcenterpiimaciescan_s3_event_rule_arn"
  value       = aws_cloudwatch_event_rule.customercallcenterpiimaciescan_s3_event_rule.arn
}
