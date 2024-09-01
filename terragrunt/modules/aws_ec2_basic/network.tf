resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_default
  availability_zone = var.aws_region
}

resource "aws_network_interface" "main" {
  subnet_id   = aws_subnet.main.id
  private_ips = ["172.16.10.100"]
}
