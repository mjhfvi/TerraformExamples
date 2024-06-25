terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "testing_ec2_instance" {
  ami           = "ami-0502e817a62226e03"
  instance_type = "t2.micro"
  monitoring    = "false"
  tags = {
    Name        = "Testing Terraform Script"
    Environment = "Home Test"
  }

}
