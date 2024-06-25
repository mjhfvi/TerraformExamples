############################################################################################################
## Terraform Script to setup windows 10 20h1 with public IP on Docker and run command,
# Terraform Environment Setup, "terraform init"
# Terraform Check Script Before Run, "terraform plan" or Use "terraform plan -out terraform_plan_Backup.tfplan" to guarantee actions is change mid plan
# Terraform Run Script, "terraform apply terraform_plan_Backup.tfplan" Or Use "terraform apply terraform_plan_Backup.tfplan -auto-approve" Without Approval Promote for Automation
# Terraform Destroy Environment, "terraform destroy" Or Use "terraform destroy -auto-approve" Without Approval Promote
############################################################################################################

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}

# Configure the Docker provider #
provider "docker" {
  host = "tcp://localhost:2375"

  # Configure Registry #
  registry_auth {
    address  = "qregistry.hub.docker.com"
    username = "mjhfvi"
    password = ""
  }
}

# Create a docker image resource
# -> docker pull mcr.microsoft.com/windows:20H2
resource "docker_image" "windows" {
  name         = "mcr.microsoft.com/windows:20H2"
  keep_locally = true
}

# Create a docker container resource
# -> same as 'docker run --name windows10 -d mcr.microsoft.com/windows:20H2'
resource "docker_container" "windows" {
  name  = "windows10"
  image = "mcr.microsoft.com/windows:20H2"
}

# Create a new docker network
resource "docker_network" "private_network" {
  name = "my_network"
}

# Access it somewhere else with ${docker_network.private_network.name}


output "Public_fqdn_Address" {
  value       = docker_container.windows.ip_address
  description = "Output -Fully Qualified Domain Name- Information to Terminal"
}

output "Public_fqdn_Address" {
  value       = docker_container.windows.ip_address
  description = "Output -Fully Qualified Domain Name- Information to Terminal"
}
