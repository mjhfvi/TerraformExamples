############ AWS Virtual Private Cloud ############
######## Gateway ########
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

######## Routes ########
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.subnet_cidr_block_public)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.main.id
}

######## Subnets ########
resource "aws_subnet" "public_subnets" {
  count                   = length(var.subnet_cidr_block_public)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidr_block_public, count.index)
  availability_zone       = element(var.aws_availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.subnet_cidr_block_private)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidr_block_private, count.index)
  availability_zone       = element(var.aws_availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}
