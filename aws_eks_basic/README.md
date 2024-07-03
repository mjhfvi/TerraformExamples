# Utilize Terraform to define the necessary infrastructure resources (e.g., virtual machines, networking) required for the Kubernetes cluster.
# For the Node group please use: “t3a-micro” only and desire,min,max sizes to 1.

# using templates from https://github.com/hashicorp/terraform-provider-aws/tree/main/examples/eks-getting-started


## Security ##
# secrets are in the "secret.tfvars"

# plan the code
terraform plan -var-file="secret.tfvars" -out=plan-out
# apply the code
terraform apply "plan-out"


# destroy the code
terraform destroy -var-file="secret.tfvars" -auto-approve
