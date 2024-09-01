output "vpc_id" {
  description = "VPC ID"
  value       = try(data.aws_vpc.current.id, null)
}

output "vpc_cidr_block" {
  description = "VPC CIDR Block"
  # value       = try(aws_vpc.main.cidr_block, null)
  value = try(data.aws_vpc.current.cidr_block, null)
}

output "aws_availability_zone" {
  description = "Availability Zone Type"
  value       = try(data.aws_availability_zones.available.id, null)
}

output "aws_region" {
  value = try(data.aws_region.current.id, null)
}

output "iam_management" {
  description = "Identity and Access Management"
  value       = try(data.aws_caller_identity.current, null)
}

# output "aws_load_balancers" {
#   value = [data.aws_lb.available.name, data.aws_lb.available.dns_name]
# }

# output "aws_internet_gateway_default" {
#   value = try(data.aws_internet_gateway.default.id, null)
# }

output "ec2_instance_type" {
  description = "AWS Instance Type"
  value       = try(var.ec2_instance_type, null)
}

# output "iam_key_pair" {
#   description = "ssh login key"
#   value       = try(data.aws_key_pair.available.tags.Name, null)
# }

# output "autoscaling_ec2_instance_public_information" {
#   description = "EC2 instance Public IPs and DNS information"
#   value       = data.aws_instances.ec2_instances
# }

# output "network_private_subnet_id" {
#   description = "Subnet ID"
#   value       = try(aws_subnet.private_subnets[*].id, null)
# }

# output "network_public_subnet_id" {
#   description = "Subnet ID"
#   value       = try(aws_subnet.public_subnets[*].id, null)
# }

# output "network_lb_public_ip" {
#   # value = try(aws_lb.main[0].dns_name, null)
#   value = try(data.aws_lb.available.id, null)
# }

# output "network_aws_subnets" {
#   value = try(data.aws_subnets.subnets_private.id, data.aws_subnets.subnets_public.id, null)
# }

# output "s3_bucket_name" {
#   description = "S3 Bucket Name"
#   # value       = try(aws_s3_bucket.main[0].bucket_domain_name, null)
#   # value = var.list != [] ? var.list : local.default_list
#   value = aws_s3_bucket.main[0].bucket_domain_name != [] ? aws_s3_bucket.main[0].bucket_domain_name : null
# }
