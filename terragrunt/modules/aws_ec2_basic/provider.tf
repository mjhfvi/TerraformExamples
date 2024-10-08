terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.56.1"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.iam_access_key
  secret_key = var.iam_secret_key

  default_tags {
    tags = {
      Build_With_Terraform = "true"
      Owner_Name           = var.owner_name
      Environment_Type     = var.environment_type
    }
  }
}
