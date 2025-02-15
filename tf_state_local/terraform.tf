terraform {
  backend "s3" {
    bucket = "demo-bucket-terraform-state-avg"
    key = "prod/aws_infra"
    region = "us-east-1"
  }
}