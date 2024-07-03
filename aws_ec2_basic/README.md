terraform init
terraform init -upgrade

# set environments var
export TF_VAR_aws_access_key=""
export TF_VAR_aws_secret_key=""


terraform plan
