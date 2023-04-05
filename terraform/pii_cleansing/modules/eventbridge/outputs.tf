output "customercallcenterpiitranscription_s3_event_rule_arn" {
  description = "comprehend_data_trigger_arn"
  value       = module.customercallcenterpiitranscription_s3_event_rule.arn
}

output "customercallcenterpiicleanedverified_s3_event_rule_arn" {
  description = "customercallcenterpiicleanedverified_s3_event_rule_arn"
  value       = module.customercallcenterpiicleanedverified_s3_event_rule.arn
}

output "customercallcenterpiiunrefined_s3_event_rule_arn" {
  description = "customercallcenterpiiunrefined_s3_event_rule_arn"
  value       = module.customercallcenterpiiunrefined_s3_event_rule.arn
}

output "customercallcenterpiicleaned_s3_event_rule_arn" {
  description = "customercallcenterpiicleaned_s3_event_rule_arn"
  value       = module.customercallcenterpiicleaned_s3_event_rule.arn
}

