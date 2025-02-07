terraform {
  backend "remote" {
    hostname     = "#{ terraformHostname }#"
    organization = "#{ System.TeamProject }#"

    workspaces {
      name = "#{ terraformWorkspace }#"
    }
  }
  required_providers {
    aws = {
      version = "5.74.0"
      source  = "hashicorp/aws"
    }
  }
}