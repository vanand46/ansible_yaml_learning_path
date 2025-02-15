provider "aws" {
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
  region = "us-east-1"
}

resource "aws_s3_bucket" "backend" {
    bucket = "myterraformstatedemo-00-backend-avg"
    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "s3_lock" {
  bucket = aws_s3_bucket.backend.id
  object_lock_enabled = "Enabled"
  depends_on = [aws_s3_bucket_versioning.enable_versioning]
}

output "s3_bucket_id" {
  value = aws_s3_bucket.backend.id
}
