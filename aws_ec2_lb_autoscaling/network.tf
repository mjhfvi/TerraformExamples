#### AWS Virtual Private Cloud ####
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_private_a
  availability_zone = var.aws_availability_zone_private

  tags = {
    Name = "subnet_private_a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_private_b
  availability_zone = var.aws_availability_zone_private

  tags = {
    Name = "subnet_private_b"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_public_a
  availability_zone = var.aws_availability_zone_public

  tags = {
    Name = "subnet_public_b"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_public_b
  availability_zone = var.aws_availability_zone_public

  tags = {
    Name = "subnet_public_b"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.main.id
}
