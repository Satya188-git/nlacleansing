provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.awsAssumeRole
    session_name = "AWS-STSSession-TF"
  }
}