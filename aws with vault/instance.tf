############################################################################################################
## Terraform Script to setup VM on AWS, Find ami ID in AWS Marketplace, using "Ubuntu Server 20.04 LTS"
# Build AWS Access Key 
# Terraform  initialize the Environment, "terraform init"
# Terraform Check Script Before Run, "terraform plan" or Use "terraform plan -out terraform_plan_Backup.tfplan"
# Terraform Run Script, "terraform apply" Or Use "terraform apply terraform_plan_Backup.tfplan" Without Approval Promote for Automation
# Terraform Destroy Environment, "terraform destroy" Or Use "terraform destroy -auto-approve" Without Approval Promote for Automation
############################################################################################################

provider "aws" {
  profile			            = "default"
  region			            = var.aws_region
  access_key                    = "${data.vault_aws_access_credentials.creds.access_key}"
  secret_key                    = "${data.vault_aws_access_credentials.creds.secret_key}"
}

provider "vault" {
 address                        = "http://192.168.50.81:8200"
 token                          = ""
}

data "vault_aws_access_credentials" "creds" {
  backend                       = "aws"
  role                          = "my-role"
}


resource "aws_instance" "my_instance" {
  ami                           = var.aws_ami
  instance_type                 = var.aws_instance_type
  associate_public_ip_address   = true
  key_name                      = "key_pair_test"
  #user_data                    = "${file("install.sh")}"           # Run Commands in VM with user_data Script
  vpc_security_group_ids        = [aws_security_group.allow_ssh.id] #aws_security_group.allow_http.id, aws_security_group.allow_https.id

 connection {
    type                        = "ssh"
	port                        = 22
    host                        = self.public_ip
    user                        = var.aws_ami_user
    private_key                 = "${file(var.ssh_key)}"
    agent                       = false
    timeout                     = "2m"
  }
}






# use "terraform output -raw public_ip" to output only the IP Terminal
## End of Terraform Script