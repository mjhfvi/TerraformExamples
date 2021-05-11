## This File Contain Security Information, Ports, Certificate Keys ##
 
 resource "aws_key_pair" "ssh-key" {
  key_name                      = "key_pair_test"
  public_key                    = var.aws_public_key
}

resource "aws_security_group" "allow_ssh" {
 name                           = "allow_ssh"
 description                    = "Allow SSH traffic"

 ingress {
   description                  = "SSH"
   from_port                    = 22
   to_port                      = 22
   protocol                     = "tcp"
   cidr_blocks                  = ["0.0.0.0/0"]
 }
 egress {
   from_port                    = 0
   to_port                      = 0
   protocol                     = "-1"
   cidr_blocks                  = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "allow_http" {
  name                          = "allow_http"
  description                   = "Allow HTTP traffic"

 ingress {
   description                  = "HTTP"
   from_port                    = 80
   to_port                      = 80
   protocol                     = "tcp"
   cidr_blocks                  = ["0.0.0.0/0"]
 }
 egress {
   from_port                    = 0
   to_port                      = 0
   protocol                     = "-1"
   cidr_blocks                  = ["0.0.0.0/0"]
 }
}
 
resource "aws_security_group" "allow_https" {
  name                          = "allow_https"
  description                   = "Allow HTTPS traffic"

 ingress {
   description                  = "HTTPS"
   from_port                    = 443
   to_port                      = 443
   protocol                     = "tcp"
   cidr_blocks                  = ["0.0.0.0/0"]
 }
 egress {
   from_port                    = 0
   to_port                      = 0
   protocol                     = "-1"
   cidr_blocks                  = ["0.0.0.0/0"]
 }
}