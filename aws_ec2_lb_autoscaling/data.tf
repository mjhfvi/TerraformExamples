data "aws_vpc" "current" {
  id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu_image" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_subnets" "subnets_private" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private*"] # insert values here
  }
}

data "aws_subnets" "subnets_public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public*"] # insert values here
  }
}

data "aws_security_groups" "available" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }

  tags = {
    Data = "security_groups"
  }
}

data "aws_security_groups" "http" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
  filter {
    name   = "group-name"
    values = ["sg_instance_http*"] # AWS 'Security group name' not 'name'
  }
  tags = {
    Data = "security_groups"
  }
}

data "aws_security_groups" "lb" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
  filter {
    name   = "group-name"
    values = ["sg_lb*"] # AWS 'Security group name' not 'name'
  }
  tags = {
    Data = "security_groups"
  }
}

data "aws_instances" "running" {
  instance_state_names = ["running", "stopped"]
}

data "aws_instances" "frontend" {
  instance_tags = {
    Name = "*frontend*"
  }
  instance_state_names = ["running"]
}

# data "aws_lb" "available" {
#   name = regex(".*-lb-main-.*", aws_lb.main[0].name)
# }

# data "aws_lb_target_group" "http" {
#   name = regex(".*-http.*", aws_lb_target_group.target_group_http.name)
# }

# data "aws_lb_target_group" "ssh" {
#   name = regex(".*-ssh.*", aws_lb_target_group.target_group_ssh.name)
# }

# data "aws_internet_gateway" "default" {
#   filter {
#     name   = "attachment.vpc-id"
#     values = [aws_vpc.main.id]
#   }
#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.main.id]
#   }
# }

# data "aws_key_pair" "available" {
#   # key_name           = "test"
#   include_public_key = true

#   filter {
#     name   = "tag:Name"
#     values = ["*ed25519*"]
#   }
# }

# data "aws_launch_template" "frontend" {
#   filter {
#     name   = "launch-template-name"
#     values = ["*frontend*"]
#   }
# }

# data "aws_ec2_instance_types" "free_tier" {
#   id = aws_vpc.main.id
#   filter {
#     name   = "free-tier-eligible"
#     values = ["true"]
#   }
# }
