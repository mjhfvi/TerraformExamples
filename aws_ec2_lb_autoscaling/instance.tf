locals {
  aws_subnets = {
    "subnet_public_a" = {
      subnet_id = aws_subnet.public_subnets[0].id
    },
    "subnet_public_b" = {
      subnet_id = aws_subnet.public_subnets[1].id
    }
  }
}

# locals {
#   instance_security_groups = {
#     "security_groups" = {
#       http  = aws_security_group.sg["http"].id,
#       https = aws_security_group.sg["https"].id,
#       ssh   = aws_security_group.sg["ssh"].id
#     }
#   }
# }

resource "aws_instance" "frontend" {
  for_each                    = local.aws_subnets
  instance_type               = var.ec2_instance_type
  ami                         = data.aws_ami.ubuntu_image.id
  key_name                    = aws_key_pair.ssh_login_access_key.key_name
  vpc_security_group_ids      = [aws_security_group.sg["http"].id, aws_security_group.sg["https"].id, aws_security_group.sg["ssh"].id]
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = var.ec2_instance_associate_public_ip_address

  root_block_device {
    volume_size           = "10"
    delete_on_termination = true
  }
  depends_on = [aws_key_pair.ssh_login_access_key]

  tags = {
    Name = "instance_name"
  }
}



# variable "ec2_instances_template" {
#   description = "Map of instance configurations"
#   type = map(object({
#     ami           = string
#     instance_type = string
#     # subnet_id     = string
#   }))
#   default = {
#     "frontend01" = {
#       ami           = "ami-0932dacac40965a65"
#       instance_type = "t3.micro"
#       # subnet_id     = ""
#     },
#     "frontend02" = {
#       ami           = "ami-0932dacac40965a65"
#       instance_type = "t3.micro"
#       # subnet_id     = ""
#     }
#   }
# }
