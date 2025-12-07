terraform {
  backend "s3" {
    bucket = "gaurav-terraform-state2003111"
    key    = "terraform.tfstate"
    region = "us-east-1"
    # No dynamodb_table here
    # Enable locking in S3
    skip_credentials_validation = true
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "gaurav-terraform-state2003111"

  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "tf_lock" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 1
    }
  }
}
#1111