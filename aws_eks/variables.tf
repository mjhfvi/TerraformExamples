variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "il-central-1" # us-east-1
}

variable "aws_user_name" {
  description = "The AWS user name"
  type        = string
  default     = "tzahi.cohen"
}

variable "aws_access_key" {
  description = "aws access_key to use for the server."
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "aws secret_key to use for the server."
  type        = string
  sensitive   = true
}

variable "owner_name" {
  description = "set the environment owner name"
  type        = string
  default     = "Tzahi.Cohen"
}

variable "environment_type" {
  description = "The AWS eks environment name"
  type        = string
  default     = "Testing"
}

variable "aws_node_groups_instance_type" {
  description = "(Optional) List of instance types associated with the EKS Node Group. Defaults to t3.medium. Terraform will only perform drift detection if a configuration value is provided"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = length(var.aws_node_groups_instance_type) > 3 && substr(var.aws_node_groups_instance_type, 3, 9) == "micro"
    error_message = "The instance_type value must be a valid instance type, ending with \"micro\"."
  }
}

variable "cluster_name" {
  description = "The AWS eks cluster name"
  type        = string
  default     = "terraform-eks-demo"
}
