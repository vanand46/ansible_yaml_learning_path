terraform {
  backend "s3" {
    bucket         = "myterraformstatedemo-00-backend-avg"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}