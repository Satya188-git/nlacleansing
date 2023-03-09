output "transcribe_lambda_role-arn" {
  description = "arn for the transcribe_lambda_role role"
  value       = aws_iam_role.transcribe_lambda_role.arn
}
output "comprehend_lambda_role-arn" {
  description = "arn for the comprehend_lambda_role role"
  value       = aws_iam_role.comprehend_lambda_role.arn
}
output "informational_macie_lambda_role-arn" {
  description = "arn for the informational_macie_lambda_role role"
  value       = aws_iam_role.informational_macie_lambda_role.arn
}
output "macie_lambda_role-arn" {
  description = "arn for the macie_lambda_role role"
  value       = aws_iam_role.macie_lambda_role.arn
}