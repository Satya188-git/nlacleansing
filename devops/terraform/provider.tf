provider "aws" {
  region = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
  assume_role {
    role_arn = "arn:aws:iam::183095018968:user/fondo/sdge-dtdes-dev-iam-user-automation"
  }
}