resource "aws_autoscaling_group" "main" {
  count               = var.create_asg ? 1 : 0
  name                = "autoscaling_group"
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  vpc_zone_identifier = [for i in aws_subnet.public_subnets[*] : i.id]
  target_group_arns   = [try(aws_lb_target_group.alb_target_group_http[0].arn, aws_lb_target_group.nlb_target_group_http[0].arn, null)]

  launch_template {
    id      = aws_launch_template.instance_launch_template[0].id
    version = aws_launch_template.instance_launch_template[0].latest_version
  }
}

resource "aws_launch_template" "instance_launch_template" {
  count         = var.create_asg ? 1 : 0
  name          = "instance_launch_template"
  image_id      = data.aws_ami.ubuntu_image.id
  instance_type = var.ec2_instance_type

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.sg["http"].id, aws_security_group.sg["https"].id, aws_security_group.sg["ssh"].id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "instance_launch_template"
    }
  }
  # user_data = var.ec2_instance_user_data
}
