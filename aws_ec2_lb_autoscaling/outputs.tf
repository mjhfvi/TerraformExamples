# output "aws_availability_zone" {
#   description = "Availability Zone Type"
#   value       = data.aws_availability_zones.available.id
# }

output "iam_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "iam_user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "iam_arn" {
  value = data.aws_caller_identity.current.arn
}

output "iam_management" {
  description = "Identity and Access Management"
  value       = aws_instance.main_a[0].id
}

output "ec2_instance_type" {
  description = "AWS Instance Type"
  value       = var.ec2_instance_type
}

output "ec2_public_ip" {
  description = "EC2 Public IPs"
  value       = [aws_instance.main_a[0].public_ip, aws_instance.main_b[0].public_ip]
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "network_cidr_block" {
  description = "VPC CIDR Block"
  value       = aws_vpc.main.cidr_block
}

output "network_private_subnet_id" {
  description = "Subnet ID"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "network_public_subnet_id" {
  description = "Subnet ID"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "network_lb_public_ip" {
  value = aws_lb.main.dns_name
}

# output "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   value       = aws_s3_bucket.main[0].bucket_domain_name
# }
