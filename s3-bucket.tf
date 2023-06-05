resource "aws_s3_bucket" "test-s3" {
  bucket = "atariya-s3-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "test-s3-ownership" {
  bucket = aws_s3_bucket.test-s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "test-s3-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.test-s3-ownership]

  bucket = aws_s3_bucket.test-s3.id
  acl    = "private"
}