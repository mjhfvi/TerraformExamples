########### Secrets, Passwords ###########
variable "iam_access_key" {
  description = "AWS access_key Credentials "
  type        = string
  sensitive   = true
}

variable "iam_secret_key" {
  description = "AWS secret_key Credentials"
  type        = string
  sensitive   = true
}

variable "ec2_access_ssh_key" {
  description = "SSH Certificate Key"
  type        = string
  sensitive   = true
}

variable "ec2_root_password" {
  description = "ec2 Instance Root Password"
  type        = string
  sensitive   = true
}

########### Infrastructure Information ###########
variable "aws_region" {
  description = "AWS Region Geographic Area"
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = length(var.aws_region) > 0 && substr(var.aws_region, 0, 9) == "eu-west-1"
    error_message = "The aws_region Value Must be - eu-west-1"
  }
}

variable "ec2_instance_count" {
  description = "Instance Count"
  type        = number
  default     = "1"

  validation {
    condition     = var.ec2_instance_count >= 1 || var.ec2_instance_count >= 4
    error_message = "you must have at least 1, and no more then 4 EC2 instances"
  }
}

variable "ec2_instance_type" {
  description = "ec2 Instance Types"
  type        = string
  default     = "t3.micro" # t3.micro

  validation {
    condition     = length(var.ec2_instance_type) > 0 && substr(var.ec2_instance_type, 0, 8) == "t3.micro"
    error_message = "The instance_type Value Must be a General Purpose Instance T(Tiny/Turbo) Type, Compute Type \"nano\"."
  }
}

variable "ec2_instance_associate_public_ip_address" {
  description = "Instance Allow Public IP Address"
  type        = string
  default     = "true"

}

########### Network Information ###########
variable "office_public_ip" {
  description = "Public IP Allow to Access"
  type        = string
  default     = "84.108.152.39/32"
}

variable "subnet_cidr_block_default" {
  description = "CIDR Block IP Range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block_public_a" {
  description = "Public Subnet CIDR Block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_block_public_b" {
  description = "Public Subnet CIDR Block"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_cidr_block_private_a" {
  description = "Private Subnet CIDR Block"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_cidr_block_private_b" {
  description = "Private Subnet CIDR Block"
  type        = string
  default     = "10.0.4.0/24"
}

variable "aws_availability_zone_public" {
  description = "Public Availability Zone"
  type        = string
  default     = "eu-west-1a"
}

variable "aws_availability_zone_private" {
  description = "Private Availability Zone"
  type        = string
  default     = "eu-west-1b"
}

########### S3 Logs Configuration ###########
variable "s3_bucket" {
  description = "Configure S3 Bucket for Logs"
  type        = bool
  default     = true
}

variable "s3_count" {
  description = "Configure S3 Bucket, Use 0 to Disable"
  type        = number
  default     = "0"
}

########### Tags Information ###########
variable "environment_name" {
  description = "Environment Name"
  type        = string
  default     = "Tzahi.Cohen"
}

variable "environment_type" {
  description = "Environment Type"
  type        = string
  default     = "Testing"
}

variable "customer_name" {
  description = "Customer Name"
  type        = string
  default     = "NICE"
}
