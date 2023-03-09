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


# grants
resource "aws_kms_grant" "unrefined_lambdaRole_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.unrefined_kms_key.key_id
  grantee_principal = var.unrefinedLambdaRole-arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "initial_lambdaRole_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.initial_kms_key.key_id
  grantee_principal = var.initialLambdaRole-arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "clean_lambdaRole_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.clean_kms_key.key_id
  grantee_principal = var.cleanLambdaRole-arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_grant" "dirty_lambdaRole_kms_key" {
  name       = "lambda_role_kms_key_1"
  key_id     = aws_kms_key.dirty_kms_key.key_id
  grantee_principal = var.dirtyLambdaRole-arn
  operations = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

