resource "aws_instance" "main" {
  count         = var.aws_instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo hello world",
    ]
  }

  # provisioner "file" {
  #   source      = "script.sh"
  #   destination = "/tmp/script.sh"
  # }
}
