provider "aws" {
  access_key = "aws-access_key"
  secret_key = "aws-secret_key"
  region = "us-east-1"
  alias = "us_east_1"
}

provider "aws" {
  access_key = "aws-access_key"
  secret_key = "aws-secret_key"
  region = "us-east-2"
  alias = "us_east_2"
}

resource "aws_instance" "example_us_east_1" {
  provider = aws.us_east_1
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "example" {
  provider = aws.us_east_2
  bucket = "my-unique-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}
