resource "aws_vpc" "main" {
  cidr_block           = var.subnet_cidr_block_default
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-${var.customer_name}"
  }
}
