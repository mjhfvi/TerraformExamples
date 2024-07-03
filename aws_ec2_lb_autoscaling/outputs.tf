output "aws_availability_zone" {
  description = "Availability Zone Type"
  value       = aws_subnet.main.availability_zone
}

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
  value       = aws_instance.main[0].ami
}

output "ec2_instance_type" {
  description = "AWS Instance Type"
  value       = aws_instance.main[0].instance_type
}

output "ec2_instance_count" {
  description = "Number of Instance"
  value       = var.ec2_instance_count
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.main[*].public_ip
}

output "ec2_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "network_cidr_block" {
  description = "VPC CIDR Block"
  value       = aws_vpc.main.cidr_block
}

output "network_subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.main.id
}

output "network_elb_public_ip" {
  value = aws_elb.main.dns_name
}

# output "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   value       = aws_s3_bucket.main[0].bucket_domain_name
# }
