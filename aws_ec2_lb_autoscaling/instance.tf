resource "aws_instance" "frontend" {
  for_each                    = local.aws_subnets
  instance_type               = var.ec2_instance_type
  ami                         = data.aws_ami.ubuntu_image.id
  key_name                    = aws_key_pair.ssh_login_access_key.key_name
  vpc_security_group_ids      = [aws_security_group.sg["http"].id, aws_security_group.sg["https"].id, aws_security_group.sg["ssh"].id]
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = var.ec2_instance_associate_public_ip_address
  user_data                   = var.ec2_instance_user_data

  root_block_device {
    volume_size           = "10"
    delete_on_termination = true
  }
  depends_on = [aws_key_pair.ssh_login_access_key]

  tags = {
    Name = "${each.key}-${var.customer_name}"
  }
}

locals {
  aws_subnets = {
    "frontend_a" = {
      subnet_id = aws_subnet.public_subnets[0].id
    },
    "frontend_b" = {
      subnet_id = aws_subnet.public_subnets[1].id
    }
  }
}
