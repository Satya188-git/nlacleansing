resource "aws_kms_key" "unrefined_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "unrefined_kms_key" {
  name          = "alias/unrefined_kms_key"
  target_key_id = aws_kms_key.unrefined_kms_key.key_id
}

# ccc_initial_bucket
resource "aws_kms_key" "initial_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}
resource "aws_kms_alias" "initial_kms_key" {
  name          = "alias/initial_kms_key"
  target_key_id = aws_kms_key.initial_kms_key.key_id
}

resource "aws_kms_key" "clean_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "clean_kms_key" {
  name          = "alias/clean_kms_key"
  target_key_id = aws_kms_key.clean_kms_key.key_id
}

resource "aws_kms_key" "dirty_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "dirty_kms_key" {
  name          = "alias/dirty_kms_key"
  target_key_id = aws_kms_key.dirty_kms_key.key_id
}

resource "aws_kms_key" "verified_clean_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}
resource "aws_kms_alias" "verified_clean_kms_key" {
  name          = "alias/verified_clean_kms_key"
  target_key_id = aws_kms_key.verified_clean_kms_key.key_id
}
# maciefindings
resource "aws_kms_key" "maciefindings_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}
resource "aws_kms_alias" "maciefindings_kms_key" {
  name          = "alias/maciefindings_kms_key"
  target_key_id = aws_kms_key.maciefindings_kms_key.key_id
}

# piimetadata
resource "aws_kms_key" "piimetadata_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}
resource "aws_kms_alias" "piimetadata_kms_key" {
  name          = "alias/maciefindings_kms_key"
  target_key_id = aws_kms_key.piimetadata_kms_key.key_id
}

# athena
resource "aws_kms_key" "athenaresults_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}
resource "aws_kms_alias" "athenaresults_kms_key" {
  name          = "alias/maciefindings_kms_key"
  target_key_id = aws_kms_key.athenaresults_kms_key.key_id
}


# grants
resource "aws_kms_grant" "transcribe_lambda_role_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.unrefined_kms_key.key_id
  grantee_principal = var.transcribe_lambda_role_arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "comprehend_lambda_role_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.initial_kms_key.key_id
  grantee_principal = var.comprehend_lambda_role_arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "infoMacie_lambda_role_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.clean_kms_key.key_id
  grantee_principal = var.informational_macie_lambda_role_arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "macie_lambda_role_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.macie_lambda_role_arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "ccc_notification_forwarder_lambda" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.macie_lambda_role_arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "ccc_macie_scan_trigger_lambda" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.trigger_macie_lambda_role_arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}