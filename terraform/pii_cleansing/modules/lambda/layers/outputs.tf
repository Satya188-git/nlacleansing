output "ccc_transcribe_lambda_archive_id" {
  description = "id for archive ccc_transcribe_lambda"
  value       = data.archive_file.ccc_transcribe_lambda_archive.id
}

output "ccc_comprehend_lambda_archive_id" {
  description = "id for archive ccc_comprehend_lambda"
  value       = data.archive_file.ccc_comprehend_lambda_archive.id
}

output "ccc_informational_macie_lambda_id" {
  description = "id for archive ccc_informational_macie_lambda"
  value       = data.archive_file.ccc_informational_macie_lambda.id
}

output "ccc_notification_forwarder_lambda_archive_id" {
  description = "id for archive ccc_notification_forwarder_lambda"
  value       = data.archive_file.ccc_notification_forwarder_lambda_archive.id
}

output "ccc_macie_scan_trigger_lambda_archive_id" {
  description = "id for archive ccc_macie_scan_trigger_lambda"
  value       = data.archive_file.ccc_macie_scan_trigger_lambda_archive.id
}

output "ccc_macie_lambda_archive_id" {
  description = "id for archive ccc_macie_lambda"
  value       = data.archive_file.ccc_macie_lambda_archive.id
}

output "ccc_audit_call_lambda_archive_id" {
  description = "ID for archive ccc_audit_call_lambda"
  value       = data.archive_file.ccc_audit_call_lambda_archive.id
}
