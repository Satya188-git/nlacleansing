output "ccc_unrefined_call_data_bucket_arn" {
  description = "ccc_unrefined_call_data_bucket S3 bucket arn"
  value       = module.ccc_unrefined_call_data_bucket.s3_bucket_arn
}

output "ccc_unrefined_call_data_bucket_id" {
  description = "ccc_unrefined_call_data_bucket S3 bucket id"
  value       = module.ccc_unrefined_call_data_bucket.s3_bucket_id
}

output "ccc_initial_bucket_arn" {
  description = "ccc_initial_bucket S3 bucket arn"
  value       = module.ccc_initial_bucket.s3_bucket_arn
}

output "ccc_initial_bucket_id" {
  description = "ccc_initial_bucket S3 bucket id"
  value       = module.ccc_initial_bucket.s3_bucket_id
}

output "ccc_cleaned_bucket_arn" {
  description = "ccc-verified-clean-bucket S3 bucket ARN"
  value       = module.ccc_cleaned_bucket.s3_bucket_arn
}

output "ccc_cleaned_bucket_id" {
  description = "ccc-verified-clean-bucket S3 bucket id"
  value       = module.ccc_cleaned_bucket.s3_bucket_id
}

output "ccc_verified_clean_bucket_arn" {
  description = "ccc-verified-clean-bucket S3 bucket ARN"
  value       = module.ccc_verified_clean_bucket.s3_bucket_arn
}

output "ccc_verified_clean_bucket_id" {
  description = "ccc-verified-clean-bucket S3 bucket id"
  value       = module.ccc_verified_clean_bucket.s3_bucket_id
}

output "ccc_dirty_bucket_arn" {
  description = "ccc_dirty_bucket S3 bucket ARN"
  value       = module.ccc_dirty_bucket.s3_bucket_arn
}

output "ccc_dirty_bucket_id" {
  description = "ccc_dirty_bucket S3 bucket id"
  value       = module.ccc_dirty_bucket.s3_bucket_id
}

output "ccc_athenaresults_bucket_arn" {
  description = "ccc_athenaresults_bucket S3 bucket ARN"
  value       = module.ccc_athenaresults_bucket.s3_bucket_arn
}

output "ccc_athenaresults_bucket_id" {
  description = "ccc_athenaresults_bucket S3 bucket id"
  value       = module.ccc_athenaresults_bucket.s3_bucket_id
}

output "ccc_piimetadata_bucket_id" {
  description = "ccc_piimetadata_bucket S3 bucket id"
  value       = module.ccc_piimetadata_bucket.s3_bucket_id
}

output "ccc_piimetadata_bucket_arn" {
  description = "ccc_piimetadata_bucket S3 bucket arn"
  value       = module.ccc_piimetadata_bucket.s3_bucket_arn
}

output "ccc_maciefindings_bucket_arn" {
  description = "ccc_maciefindings_bucket S3 bucket ARN"
  value       = module.ccc_maciefindings_bucket.s3_bucket_arn
}

output "ccc_maciefindings_bucket_id" {
  description = "ccc_maciefindings_bucket S3 bucket ID"
  value       = module.ccc_maciefindings_bucket.s3_bucket_id
}

output "ccc_insights_audio_bucket_arn" {
  description = "ccc_insights_audio_bucket S3 bucket ARN"
  value       = module.ccc_insights_audio_bucket.s3_bucket_arn
}

output "ccc_insights_audio_bucket_id" {
  description = "ccc_insights_audio_bucket S3 bucket name"
  value       = module.ccc_insights_audio_bucket.s3_bucket_id
}

output "ccc_callrecordings_bucket_arn" {
  description = "ccc_callrecordings_bucket S3 bucket ARN"
  value       = module.ccc_callrecordings_bucket.s3_bucket_arn
}

output "ccc_callrecordings_bucket_id" {
  description = "ccc_callrecordings_bucket S3 bucket ID"
  value       = module.ccc_callrecordings_bucket.s3_bucket_id
}
output "ccc_callaudioaccesslogs_bucket_id" {
  description = "ccc_callaudioaccesslogs_bucket S3 bucket ID"
  value       = module.ccc_callaudioaccesslogs_bucket.s3_bucket_id
}

output "ccc_nla_access_logs_bucket_id" {
  description = "ccc_nla_access_logs_bucket S3 bucket ID"
  value       = module.ccc_nla_access_logs_bucket.s3_bucket_id
}

output "ccc_historical_calls_bucket_id" {
  description = "ccc_historical_calls_bucket S3 bucket ID"
  value = module.ccc_historical_calls_bucket.s3_bucket_id
}

output "ccc_historical_calls_bucket_arn" {
  description = "ccc_historical_calls_bucket S3 bucket ID"
  value = module.ccc_historical_calls_bucket.s3_bucket_arn
}