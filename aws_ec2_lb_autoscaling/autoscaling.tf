resource "aws_autoscaling_group" "frontend" {
  # count               = var.create_asg == true ? 1 : 0
  name                = "autoscaling_group_frontend"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  vpc_zone_identifier = [for key in aws_subnet.public_subnets[*] : key.id]
  # target_group_arns   = [for key in aws_lb_target_group.target_group[*] : key.arn]
  target_group_arns = [aws_lb_target_group.target_group["22"].arn, aws_lb_target_group.target_group["80"].arn]

  launch_template {
    id      = try(aws_launch_template.instance_launch_template[0].id, null)
    version = try(aws_launch_template.instance_launch_template[0].latest_version, null)
  }
}

resource "aws_launch_template" "instance_launch_template" {
  count         = var.create_asg == true ? 1 : 0
  name          = "autoscaling_template_frontend"
  description   = "aws launch template for autoscaling frontend"
  image_id      = try(data.aws_ami.ubuntu_image.id, null)
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ssh_login_access_key.key_name # try(data.aws_key_pair.available.key_name, null)
  user_data     = filebase64("${path.module}/ec2_instance_init.sh")

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg_instance.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "autoscaling_frontend_${count.index}"
    }
  }
}

resource "aws_autoscaling_policy" "frontend" {
  autoscaling_group_name = "autoscaling_group_frontend_policy"
  name                   = "autoscaling_policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value = 100
    customized_metric_specification {
      metrics {
        label = "Get the queue size (the number of messages waiting to be processed)"
        id    = "m1"
        metric_stat {
          metric {
            namespace   = "AWS/SQS"
            metric_name = "ApproximateNumberOfMessagesVisible"
            dimensions {
              name  = "QueueName"
              value = "my-queue"
            }
          }
          stat = "Sum"
        }
        return_data = false
      }
      metrics {
        label = "Get the group size (the number of InService instances)"
        id    = "m2"
        metric_stat {
          metric {
            namespace   = "AWS/AutoScaling"
            metric_name = "GroupInServiceInstances"
            dimensions {
              name  = "AutoScalingGroupName"
              value = "my-asg"
            }
          }
          stat = "Average"
        }
        return_data = false
      }
      metrics {
        label       = "Calculate the backlog per instance"
        id          = "e1"
        expression  = "m1 / m2"
        return_data = true
      }
    }
  }
}

resource "aws_autoscaling_notification" "notifications" {
  group_names = [
    aws_autoscaling_group.frontend.id,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.example.arn
}

resource "aws_sns_topic" "example" {
  name = "example-topic"

  # arn is an exported attribute
}
