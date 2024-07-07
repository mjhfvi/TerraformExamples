resource "aws_s3_bucket" "lb_log_bucket" {
  bucket = "tf-log-bucket"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.lb_log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "lb-logs" {
  bucket = aws_s3_bucket.lb-logs.id

  target_bucket = aws_s3_bucket.lb_log_bucket.id
  target_prefix = "log/"
}
