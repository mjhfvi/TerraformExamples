resource "aws_s3_bucket" "lb_log_bucket" {
  count  = var.create_s3 ? 1 : 0
  bucket = "tf-log-bucket"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  count  = var.create_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb_log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "lb-logs" {
  count  = var.create_s3 ? 1 : 0
  bucket = aws_s3_bucket.lb-logs.id

  target_bucket = aws_s3_bucket.lb_log_bucket.id
  target_prefix = "log/"
}
