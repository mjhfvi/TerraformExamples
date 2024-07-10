resource "aws_security_group" "sg_instance" {
    vpc_id              = try(aws_vpc.main.id, null)
    name                = "security_group_instance"
    description         = "Security Group for Web Servers"

    dynamic "ingress" {
      for_each = local.instance_rules
      content {
        description = ingress.value.description
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sg_instance"
    Data = "security_groups"
  }
}

resource "aws_security_group" "sg_lb" {
    vpc_id              = try(aws_vpc.main.id, null)
    name                = "security_group_lb"
    description         = "Security Group for Load Balancer"

    dynamic "ingress" {
      for_each = local.lb_rules
      content {
        description = ingress.value.description
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sg_lb"
    Data = "security_groups"
  }
}

locals {
  lb_rules = [{
    description = "HTTP",
    from_port = 80,
    to_port = 80,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
  },{
    description = "SSH",
    from_port = 22,
    to_port = 22,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
  },{
    description = "HTTPS",
    from_port = 443,
    to_port = 443,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
  }]
}

locals {
  instance_rules = [{
    description = "HTTP",
    from_port = 80,
    to_port = 80,
    protocol    = "tcp",
    cidr_blocks = [var.office_public_ip],
  },{
    description = "SSH",
    from_port = 22,
    to_port = 22,
    protocol    = "tcp",
    cidr_blocks = [var.office_public_ip],
  },{
    description = "HTTPS",
    from_port = 443,
    to_port = 443,
    protocol    = "tcp",
    cidr_blocks = [var.office_public_ip],
  }]
}
