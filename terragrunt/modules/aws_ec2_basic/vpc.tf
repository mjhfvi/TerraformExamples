resource "aws_vpc" "main" {
  cidr_block = var.subnet_cidr_block_default
}
