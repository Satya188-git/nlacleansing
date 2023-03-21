terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
   organization = "SempraUtilities"
 
   workspaces {
      # name = "#{terraformWorkspace}#"
      name = "sdge-dev_sdge-it-nla"
    }
  }
}