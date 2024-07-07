resource "aws_security_group" "sg" {
  for_each    = var.aws_security_group_template
  name        = "sg_${each.value.name}"
  description = "allow access to ${each.value.name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = each.value.from_port
    to_port     = each.value.to_port
    protocol    = each.value.protocol
    cidr_blocks = [each.value.cidr_blocks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "sg_allow_${each.value.name}"
  }
}
