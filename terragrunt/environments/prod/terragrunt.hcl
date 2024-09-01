include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//aws_ec2_basic"

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
    ]

    # With the get_terragrunt_dir() function, you can use relative paths!
    arguments = [
      "-var-file=${get_terragrunt_dir()}/../secret.tfvars",
    ]
  }
}


inputs = {
  aws_region          = "us-east-2"
  AZ1             = "us-east-2a"       // for EC2
  AZ2             = "us-east-2b"       //for RDS
  AZ3             = "us-east-2c"       //for RDS
  VPC_cidr        = "10.10.0.0/16"     // VPC CIDR
  subnet1_cidr    = "10.10.1.0/24"     // Public Subnet for EC2
  subnet2_cidr    = "10.10.2.0/24"     //Private Subnet for RDS
  subnet3_cidr    = "10.10.3.0/24"     //Private subnet for RDS
  instance_type   = "t2.nano"    //type of instance
  owner_name   = "tzahi.cohen"
  aws_user_name = "tzahi.cohen"
  environment_type= "prod"
  ec2_root_password = "123456"
}
