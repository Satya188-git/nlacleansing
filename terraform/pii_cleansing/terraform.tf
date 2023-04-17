# terraform {
#   backend "remote" {
#     hostname     = "#{ terraformHostname }#"
#     organization = "#{ System.TeamProject }#"

#     workspaces {
#       name = "#{ terraformWorkspace }#"
#     }
#   }
# }
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
   organization = "SempraUtilities"
 
   workspaces {
      name = "sdge-qa_sdge-it-nla"
    }
  }
}
