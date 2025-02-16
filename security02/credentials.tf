provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region = "us-east-1"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
