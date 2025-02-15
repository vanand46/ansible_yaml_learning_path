provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
    bucket = "demo-bucket-terraform-state-avg"
}