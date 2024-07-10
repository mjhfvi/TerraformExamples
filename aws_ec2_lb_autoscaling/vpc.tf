resource "aws_vpc" "main" {
  cidr_block           = try(var.subnet_cidr_block_default, null)
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-${var.customer_name}"
  }
}
