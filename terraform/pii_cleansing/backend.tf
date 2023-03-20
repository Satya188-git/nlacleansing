terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
   organization = "SempraUtilities"
 
   workspaces {
      name = "#{terraformWorkspace}#"
    }
  }
}