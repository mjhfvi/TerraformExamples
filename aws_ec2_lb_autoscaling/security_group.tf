resource "aws_security_group" "sg" {
  for_each    = var.aws_security_group_template
  name        = "sg_${each.value.name}"
  description = "allow access to ${each.value.name}"
  vpc_id      = try(aws_vpc.main.id, null)

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
    Data = "security_groups"
  }
}

variable "aws_security_group_template" {
  description = "Map of security group configurations"
  type = map(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string

  }))
  default = {
    "instance-http" = {
      name        = "instance-http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "84.108.152.39/32"
    },
    # "instance-https" = {
    #   name        = "instance-https"
    #   from_port   = 443
    #   to_port     = 443
    #   protocol    = "tcp"
    #   cidr_blocks = "0.0.0.0/0"
    # },
    "instance-ssh" = {
      name        = "instance-ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "84.108.152.39/32"
    },
    "lb-http" = {
      name        = "lb-http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    # "lb-https" = {
    #   name        = "lb-https"
    #   from_port   = 443
    #   to_port     = 443
    #   protocol    = "tcp"
    #   cidr_blocks = "0.0.0.0/0"
    # },
    "lb-ssh" = {
      name        = "lb-ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  }
}
