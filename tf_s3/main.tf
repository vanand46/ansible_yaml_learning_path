provider "aws" {
    access_key = "your access_key"
    secret_key = "your secret_key"
    region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
    bucket = "demo-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
    byte_length = 8
}