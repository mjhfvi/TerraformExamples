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
      Build_With_Terraform = "True"
      Customer_Name        = var.customer_name
      Owner_Name           = var.environment_name
      Environment_Type     = var.environment_type
    }
  }
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
# data "aws_subnet" "available" {}
