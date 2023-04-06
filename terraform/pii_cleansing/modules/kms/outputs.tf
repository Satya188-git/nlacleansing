output "kms_key_ccc_unrefined_arn" {
  value = aws_kms_key.unrefined_kms_key.arn
}
output "kms_key_ccc_initial_arn" {
  value = aws_kms_key.initial_kms_key.arn
}

output "kms_key_ccc_clean_arn" {
  value = aws_kms_key.clean_kms_key.arn
}
output "kms_key_ccc_verified_clean_arn" {
  value = aws_kms_key.verified_clean_kms_key.arn
}

output "kms_key_ccc_dirty_arn" {
  value = aws_kms_key.dirty_kms_key.arn
}

# kms_key_ccc_maciefindings_arn
output "kms_key_ccc_maciefindings_arn" {
  value = aws_kms_key.maciefindings_kms_key.arn
}

# kms_key_ccc_piimetadata_arn
output "kms_key_ccc_piimetadata_arn" {
  value = aws_kms_key.piimetadata_kms_key.arn
}

# kms_key_ccc_athenaresults_arn
output "kms_key_ccc_athenaresults_arn" {
  value = aws_kms_key.athenaresults_kms_key.arn
}

output "kms_key_ccc_sns_lambda_arn" {
  value = aws_kms_key.sns_lambda_kms_key.arn
}

output "athena_kms_key_arn" {
  value = module.athena_kms_key.key_arn
}
