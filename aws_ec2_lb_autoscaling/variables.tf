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

########### AWS Identity and Access Management ###########
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

variable "aws_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "ec2_instance_associate_public_ip_address" {
  description = "Instance Allow Public IP Address"
  type        = string
  default     = true

}

variable "subnet_associate_public_ip_address" {
  description = "Instance Allow Public IP Address"
  type        = string
  default     = "true"
}

########### Office IP Information ###########
variable "office_public_ip" {
  description = "Public IP Allow to Access"
  type        = string
  default     = "84.108.152.39/32"
}

########### Instance Certificates and Passwords ###########
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

########### Instance Creation ###########
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

variable "ec2_instance_user_data" {
  type        = string
  description = "Run Commands at Instance boot, Logs:  /var/log/cloud-init-output.log"
  default     = <<-EOF
    #!/usr/bin/env bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo ufw allow 'Nginx HTTP'
    sudo ufw enable
  EOF
}

########### CIDR Creation ###########
variable "subnet_cidr_block_default" {
  description = "CIDR Block IP Range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block_public" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "subnet_cidr_block_private" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
}

########### Load Balancing Creation ###########
variable "create_lb" {
  description = "A boolean to decide whether to create Application Load Balancing"
  type        = bool
  default     = false
}

variable "configure_lb" {
  description = "configure Network Load Balancing as Application or Network"
  type        = string
  default     = "application"
  # default     = "network"
}

########### Autoscaling Creation ###########
variable "create_asg" {
  description = "A boolean to decide whether to create autoscaling"
  type        = bool
  default     = false
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

########### Templates ###########
variable "aws_security_group_template" {
  description = "Map of security group configurations"
  type = map(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string

  }))
  default = {
    "http" = {
      name        = "http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    "https" = {
      name        = "https"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    "ssh" = {
      name        = "ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  }
}
