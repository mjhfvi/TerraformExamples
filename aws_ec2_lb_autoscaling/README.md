This is an example for launching instances with autoscaling group, and using network load balancer to access the instances
SSH is open publicly to the load balancer, and open to the instances only to the office IP address

# Prerequisites
ed25519 certificate

# build new certificate command
ssh-keygen -t ed25519 -C "USER_NAME SSH Login Key ed25519 with Password" -f ssh_login_key_ed25519 -N SetPassword

##### Configure Terraform #####
# Set Resources Variables
file 'secret.tfvars':
set AWS iam access_key and secret_key
set the public certificate with ec2_access_ssh_key

file 'variables.tf':
set the office IP address in office_public_ip
general information, set environment name, environment type, customer name
aws information, set aws region, availability zones, ec2 instance type, subnet cidr

file 'autoscaling.tf':
set Number of min and max instance

## Build AWS Environments ##
# Initialize Terraform
terraform init

# Run Terraform with tfvars File and Save Plan File
terraform plan -var-file=secret.tfvars -out=tfplan

# Build Terraform Infrastructure
terraform apply "tfplan"

when done, you will get an output with build information
use 'aws_load_balancers' to get the lb dns name

### Destroy Terraform Infrastructure ###
terraform destroy -auto-approve -var-file=secret.tfvars


## Resources Validation
for ec2 Instance, you can only use "t3.micro" type, and no more then 2 Instance
region il-central-1 in not compatible with t2.nano, only t3.micro

#### Security Best Practices ####
## Secrets
# Option 1 - Use tfvars file
set aws secret_key & access_key in secret.tfvars
set ssh login certificate ssh_key in secret.tfvars
# Option 2 - Set Environments Variables
export TF_VAR_aws_access_key=""
export TF_VAR_aws_secret_key=""

# Code
Don`t commit .tfvars, .tfstate, .tfplan files to git (use .gitignore)
use secure storage to store the tfstate file, S3 bucket is an option

## Test On ##
# AWS Region
"eu-west-1" - Europe (Ireland)
# AWS Instance Type
support free tier instance type "t2.micro"
# AWS Autoscaling - Supported Regions
https://console.aws.amazon.com/awsautoscaling/home?region=il-central-1#

#### Troubleshooting ####
export TF_LOG=DEBUG
