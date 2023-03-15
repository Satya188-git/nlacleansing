terraform {
  backend "local" {
    path = "devops/terraform/.terraform/terraform.tfstate"
  }
}
