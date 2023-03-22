terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
   organization = "SempraUtilities"
 
   workspaces {
      name = "sdge-dev_sdge-it-nla"
    }
  }
}