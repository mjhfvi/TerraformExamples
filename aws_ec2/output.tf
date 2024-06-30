# output "instance_type" {
#   description = "AWS Instance Type"
#   value       = aws_instance.main.[*]instance_type
# }

output "instance_type" {
  description = "AWS Instance Type"
  value       = aws_instance.main.*.instance_type
  #  { for i in aws_instance.main : i.tags.Name => "${i.id}:${i.instance_type}" }
}

output "cidr_block" {
  description = "VPC cidr_block"
  value       = aws_vpc.main.cidr_block
}

output "availability_zone" {
  description = "availability_zone Type"
  value       = aws_subnet.main.availability_zone
}

# output "public_ip" {
#   description = "public_ip"
#   value       = aws_instance.main[count.index]
# }

output "test" {
  value = try(aws_subnet.main.availability_zone, "default")
}
