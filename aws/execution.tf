## This File Contain Execute Commands ##
 
# Check if the VM is Ready to Start Execute a Command 
resource "null_resource" "instance_check" {
  provisioner "remote-exec" {
    connection {
      host                      = aws_instance.my_instance.public_ip
      user                      = var.aws_ami_user
      private_key               = "${file(var.ssh_key)}"
      timeout                   = "1m"
    }
    inline                      = ["echo 'SSH Connection Check Complete...'"]
    on_failure                  = continue
  }
}

#resource "null_resource" "exec_ansible" {
#  provisioner "local-exec" {
#Run Ansible File from Local Folder Example
#    command                    = "ansible-playbook install.yml '--key-file=${var.ssh_key}' -i '${aws_instance.my_instance.public_ip},'"
#Run Ansible File From Github Repository Example
#      command                    = "wget https://raw.githubusercontent.com/mjhfvi/Ansible-Examples/main/aws/install.yml && ansible-playbook install.yml '--key-file=${var.ssh_key}' -i '${aws_instance.my_instance.public_ip},'"
#     command                    = "echo self.private_ip >> private_ips.txt"
#     on_failure                 = continue
#  }
#  depends_on                   = [null_resource.instance_check]
#}



  
#resource "null_resource" "sleep" {
#  provisioner "local-exec" {
#    command                    = "sleep 15"
#  }
#  depends_on                   = [aws_instance.my_instance]
#}

#resource "null_resource" "get_ip" {
#  provisioner "local-exec" {
#    command                     = "echo self.private_ip >> private_ips.txt"
#  }
#}