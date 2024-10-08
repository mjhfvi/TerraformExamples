variable "iam_access_key" {
  description = "aws access_key to use for the server."
  type        = string
  sensitive   = true
}

variable "iam_secret_key" {
  description = "aws secret_key to use for the server."
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
  # default     = "il-central-1" # us-east-1
}

variable "aws_user_name" {
  description = "The AWS user name"
  type        = string
  default     = "tzahi.cohen"
}

variable "owner_name" {
  description = "set the environment owner name"
  type        = string
  # default     = "Tzahi.Cohen"
}

variable "environment_type" {
  description = "The AWS eks environment name"
  type        = string
  # default     = "Testing"
}

variable "instance_type" {
  description = "(Optional) List of instance types associated with the EKS Node Group. Defaults to t3.medium. Terraform will only perform drift detection if a configuration value is provided"
  type        = string
  default     = "t2.nano" # t2.nano, t3.micro

  validation {
    condition     = length(var.instance_type) > 3 && substr(var.instance_type, 3, 9) == "nano"
    error_message = "The instance_type value must be a valid instance type, ending with \"nano\"."
  }
}

variable "aws_instance_count" {
  description = "AWS Instance Count"
  type        = string
  default     = "1"
}

variable "root_password" {
  description = "Instance Root Password"
  type        = string
  default     = ""
}

variable "subnet_cidr_block_default" {
  description = "CIDR Block IP Range"
  type        = string
  default     = "10.0.0.0/16"
}
