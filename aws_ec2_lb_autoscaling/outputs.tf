output "aws_availability_zone" {
  description = "Availability Zone Type"
  value       = try(data.aws_availability_zones.available.id, null)
}

output "iam_management" {
  description = "Identity and Access Management"
  # value       = try(data.aws_caller_identity.current.arn, data.aws_caller_identity.current.account_id, data.aws_caller_identity.current.user_id, null)
  value = try(data.aws_caller_identity.current[*], null)
}

output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.main.id, null)
}

output "ec2_instance_type" {
  description = "AWS Instance Type"
  value       = try(var.ec2_instance_type, null)
}

output "ec2_instance_public_information" {
  description = "EC2 instance Public IPs"
  value       = [try(aws_instance.frontend["subnet_public_a"].public_ip, aws_instance.frontend["subnet_public_a"].public_dns, null)]
  # value       = try(aws_instance.main_a[0].public_ip, aws_instance.main_b[0].public_ip, null)
}

output "network_cidr_block" {
  description = "VPC CIDR Block"
  value       = try(aws_vpc.main.cidr_block, null)
}

output "network_private_subnet_id" {
  description = "Subnet ID"
  value       = try(aws_subnet.private_subnets[*].id, null)
}

output "network_public_subnet_id" {
  description = "Subnet ID"
  value       = try(aws_subnet.public_subnets[*].id, null)
}

output "network_lb_public_ip" {
  value = try(aws_lb.main[0].dns_name, null)
}

output "network_aws_subnets" {
  value = data.aws_subnets.subnets.id
}

# output "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   # value       = try(aws_s3_bucket.main[0].bucket_domain_name, null)
#   # value = var.list != [] ? var.list : local.default_list
#   value = aws_s3_bucket.main[0].bucket_domain_name != [] ? aws_s3_bucket.main[0].bucket_domain_name : null
# }
