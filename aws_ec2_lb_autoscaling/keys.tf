resource "aws_key_pair" "ssh_login_access_key" {
  key_name   = "ed25519_ssh_login_key"
  public_key = try(var.ec2_access_ssh_key, null)

  tags = {
    Name = "openssh login ed25519 ssh key with password"
  }
}
