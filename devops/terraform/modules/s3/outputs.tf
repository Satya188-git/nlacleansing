
# Customercallcenterpiiunrefined 
output "ccc_unrefined_call_data_bucket-arn" {
  description = "ccc_unrefined_call_data_bucket S3 bucket arn"
  value       = module.ccc_unrefined_call_data_bucket.s3_bucket_arn
}

# customercallcenterpiitranscription
output "ccc_initial_bucket-arn" {
  description = "ccc_initial_bucket S3 bucket arn"
  value       = module.ccc_initial_bucket.s3_bucket_arn
}

# Customercallcenterpiicleaned
output "ccc_cleaned_bucket-arn" {
  description = "ccc-verified-clean-bucket S3 bucket ARN"
  value       = module.ccc_cleaned_bucket.s3_bucket_arn
}

# Customercallcenterpiicleanedverified
output "ccc_verified_clean_bucket-arn" {
  description = "ccc-verified-clean-bucket S3 bucket ARN"
  value       = module.ccc_verified_clean_bucket.s3_bucket_arn
}


# customercallcenterpiidirty
output "ccc_dirty_bucket-arn" {
  description = "ccc_dirty_bucket S3 bucket ARN"
  value       = module.ccc_dirty_bucket.s3_bucket_arn
}

# customercallcenterathenaresults
output "ccc_athenaresults_bucket-arn" {
  description = "ccc_athenaresults_bucket S3 bucket ARN"
  value       = module.ccc_athenaresults_bucket.s3_bucket_arn
}

# customercallcenterpiimetadata
output "ccc_piimetadata_bucket-arn" {
  description = "ccc_piimetadata_bucket S3 bucket ARN"
  value       = module.ccc_piimetadata_bucket.s3_bucket_arn
}

# customercallcentermaciefindings
output "ccc_maciefindings_bucket-arn" {
  description = "ccc_maciefindings_bucket S3 bucket ARN"
  value       = module.ccc_maciefindings_bucket.s3_bucket_arn
}