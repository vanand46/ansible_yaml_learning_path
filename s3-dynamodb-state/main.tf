terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "demo_org_avg"

    workspaces { 
      name = "my-aws-app" 
    } 
  }
}