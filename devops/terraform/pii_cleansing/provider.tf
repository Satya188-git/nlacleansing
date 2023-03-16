provider "aws" {
  region = "us-west-2"
  # shared_credentials_files = ["~/.aws/credentials"]
  assume_role {
    role_arn = "arn:aws:iam::183095018968:role/fondo/sdge-dtdes-dev-iam-role-ado-beta"
    session_name = "AWS-STSSession-TF"
  }
}