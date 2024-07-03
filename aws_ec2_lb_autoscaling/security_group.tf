resource "aws_security_group" "http" {
  name        = "sg_http"
  description = "allow access to http"
  vpc_id      = aws_vpc.main.id

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [var.office_public_ip]
  # }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_alb_allow_http"
  }
}

resource "aws_security_group" "ssh" {
  name        = "sg_ssh"
  description = "allow access to opnessh on ssh"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.office_public_ip]
  }

  tags = {
    Name = "sg_allow_ssh"
  }
}

resource "aws_security_group" "lb" {
  name        = "sg_elb"
  description = "allow access to lb on http"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "sg_alb_allow_http"
  }
}
