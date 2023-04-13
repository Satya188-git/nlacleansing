terraform {
  backend "remote" {
    hostname     = "#{ terraformHostname }#"
    organization = "#{ System.TeamProject }#"

    workspaces {
      name = "#{ terraformWorkspace }#"
    }
  }
}
