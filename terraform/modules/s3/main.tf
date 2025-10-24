variable "bucket_id" { type = string }

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_id
  acl    = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
