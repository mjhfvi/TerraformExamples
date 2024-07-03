resource "aws_instance" "main_a" {
  count                       = var.ec2_instance_count
  instance_type               = var.ec2_instance_type
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh_login_access_key.key_name
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.private_a.id
  associate_public_ip_address = var.ec2_instance_associate_public_ip_address
  # user_data              = file("userdata.sh")

  root_block_device {
    volume_size           = "10"
    delete_on_termination = true
  }
  depends_on = [aws_key_pair.ssh_login_access_key]

  tags = {
    Name = "instance_main_a"
  }
}

resource "aws_instance" "main_b" {
  count                       = var.ec2_instance_count
  instance_type               = var.ec2_instance_type
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh_login_access_key.key_name
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.private_b.id
  associate_public_ip_address = var.ec2_instance_associate_public_ip_address
  # user_data              = file("userdata.sh")

  root_block_device {
    volume_size           = "10"
    delete_on_termination = true
  }
  depends_on = [aws_key_pair.ssh_login_access_key]

  tags = {
    Name = "instance_main_b"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
}
