terraform {
  source = "../modules//aws_ec2_basic"

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
    ]

    # With the get_terragrunt_dir() function, you can use relative paths!
    arguments = [
      "-var-file=secret.tfvars",
    ]
  }
}



inputs = {
  aws_region          = "us-east-2"

  instance_type   = "t2.nano"    //type of instance
  owner_name   = "tzahi.cohen"
  aws_user_name = "tzahi.cohen"
  ec2_root_password = "123456"
}
