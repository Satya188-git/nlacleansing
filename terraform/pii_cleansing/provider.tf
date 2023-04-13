provider "aws" {
  #alias = "nla-pii"
  region = var.region
  assume_role {
    role_arn     = var.aws_assume_role_pii
    session_name = "AWS-STSSession-PII"
  }
}
