##### Terraform with Instance, ELB, Autoscaling
The example launches 2 instance and limited to 4 instance
login to instance with openssh ed25519 certificate,
using ELB for instances
creates security groups for the ELB and EC2 instance.
creates autoscaling

##### Configure Terraform #####
## Limitation ##
# AWS Autoscaling - Supported Regions
https://console.aws.amazon.com/awsautoscaling/home?region=il-central-1#
tested on: "eu-west-1" - Europe (Ireland)

# AWS Instance Type
eu-west-1 - Europe (Ireland) support free tier instance type "t2.micro"

## Secrets
# Option 1 - Use tfvars file
set aws secret_key & access_key in secret.tfvars
set ssh login certificate ssh_key in secret.tfvars
# Option 2 - Set Environments Variables
export TF_VAR_aws_access_key=""
export TF_VAR_aws_secret_key=""

## Resources Validation
for ec2 Instance, you can only use "t3.micro" type, and no more then 2 Instance
region il-central-1 in not compatible with t2.nano, only t3.micro

## Resources Variables
set Number of Instance in "variables.tf" Variable "ec2_instance_count"

# Initialize Terraform
terraform init
terraform init -upgrade

## Build AWS Environments ##
# Test Terraform with tfvars File
terraform plan -var-file=secret.tfvars

# Run Terraform with tfvars File and Save Plan File
terraform plan -var-file=secret.tfvars -out=tfplan

# Build Terraform Infrastructure
terraform apply "tfplan"


#### Security ####
# OpenSSH login Certificate to Instances
ssh-keygen -t ed25519 -C "Tzahi Cohen SSH Login Key ed25519 with Password" -f ssh_login_key_ed25519 -m PEM -N Password

Don`t commit files to git (use .gitignore)
.tfvars, .tfstate, .tfplan
use secure storage to store the tfstate file, S3 bucket is an option

### Destroy Terraform Infrastructure ###
terraform destroy -auto-approve -var-file=secret.tfvars

#### Troubleshooting ####
export TF_LOG=DEBUG
