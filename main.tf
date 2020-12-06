terraform {
  required_providers {
    aws = {
      source		= "hashicorp/aws"
      version		= "~> 2.70"
    }
  }
}

provider "aws" {
  region			= var.region
  access_key		= var.aws_access_key
  secret_key		= var.aws_secret_key
}

resource "aws_instance" "testing_ec2_instance" {
  ami				= "ami-0502e817a62226e03"
  instance_type		= "t2.micro"
  monitoring        = "false"
  tags = {
    Name 			= "Testing Terraform Script"
	Environment 	= "Home Test"
  }
   
}
