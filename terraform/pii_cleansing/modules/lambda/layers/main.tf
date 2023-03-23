data "archive_file" "ccc_transcribe_lambda_archive" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_transcribe_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_transcribe_lambda.zip"
}

data "archive_file" "ccc_comprehend_lambda_archive" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_comprehend_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_comprehend_lambda.zip"
}

data "archive_file" "ccc_informational_macie_lambda" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_informational_macie_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_informational_macie_lambda.zip"
}
data "archive_file" "ccc_notification_forwarder_lambda_archive" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_notification_forwarder_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_notification_forwarder_lambda.zip"
}


data "archive_file" "ccc_macie_scan_trigger_lambda_archive" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_macie_scan_trigger_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_macie_scan_trigger_lambda.zip"
}

data "archive_file" "ccc_macie_lambda_archive" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_macie_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_macie_lambda.zip"
}

data "archive_file" "ccc_audit_call_lambda_archive" {
  type        = "zip"
  source_dir  = "${path.root}/../../backend/python/src/ccc_audit_call_lambda"
  output_path = "${path.root}/../../backend/python/src/zip_packages/ccc_audit_call_lambda.zip"
}
