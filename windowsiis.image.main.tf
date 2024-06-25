terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "windowsiis" {
  name         = "mcr.microsoft.com/windows/servercore/iis"
  keep_locally = false
}

resource "docker_container" "windowsiis" {
  image = docker_image.windowsiis.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}

## docker pull mcr.microsoft.com/windows/servercore/iis
# terraform init
# terraform apply
# terraform destroy
