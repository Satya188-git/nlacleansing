output "kms_key_ccc_unrefined-arn" {
  value = aws_kms_key.unrefined_kms_key.arn
}
output "kms_key_ccc_initial-arn" {
  value = aws_kms_key.initial_kms_key.arn
}

output "kms_key_ccc_clean-arn" {
  value = aws_kms_key.clean_kms_key.arn
}

output "kms_key_ccc_dirty-arn" {
  value = aws_kms_key.dirty_kms_key.arn
}

