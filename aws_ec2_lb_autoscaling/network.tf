######## Gateway ########
resource "aws_internet_gateway" "main" {
  vpc_id = try(data.aws_vpc.current.id, null)
}

######## Routes ########
resource "aws_route_table" "main" {
  vpc_id = try(data.aws_vpc.current.id, null)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = try(aws_internet_gateway.main.id, null)
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.subnet_cidr_block_public)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.subnet_cidr_block_private)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.main.id
}

######## Subnets ########
resource "aws_subnet" "public_subnets" {
  count                   = length(var.subnet_cidr_block_public)
  vpc_id                  = try(data.aws_vpc.current.id, null)
  cidr_block              = element(var.subnet_cidr_block_public, count.index)
  availability_zone       = element(var.aws_availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.subnet_cidr_block_private)
  vpc_id                  = try(data.aws_vpc.current.id, null)
  cidr_block              = element(var.subnet_cidr_block_private, count.index)
  availability_zone       = element(var.aws_availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}
