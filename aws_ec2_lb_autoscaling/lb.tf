resource "aws_lb" "main" {
  count              = var.create_lb ? 1 : 0
  name               = "${var.configure_lb}-lb-main-${var.customer_name}"
  internal           = false
  load_balancer_type = var.configure_lb
  # security_groups    = try(data.aws_security_groups.lb.ids, null)
  security_groups    = [aws_security_group.sg_lb.id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.public_subnets[2].id]
  # subnets            = try([for key in aws_subnet.public_subnets[*] : key.id], null)

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_log_bucket[0].id
  #   prefix  = "logs-lb"
  #   enabled = true
  # }
  tags = {
    Name = "lb-main"
  }
}

resource "aws_lb_target_group" "target_group" {
  for_each = var.configure_lb == "application" ? local.ports.application_lb_ports : local.ports.network_lb_ports
  name     = "lb-target-group-${each.key}"
  port     = each.key
  protocol = each.value
  vpc_id   = try(data.aws_vpc.current.id, null)
}

resource "aws_lb_listener" "listener" {
  for_each = var.configure_lb == "application" ? local.ports.application_lb_ports : local.ports.network_lb_ports
  # load_balancer_arn = try(data.aws_lb.available.arn, null)
  load_balancer_arn = aws_lb.main[0].arn
  port              = each.key
  protocol          = each.value

  default_action {
    type             = "forward"
    target_group_arn = try(aws_lb_target_group.target_group[each.key].arn, null)
  }
}

locals {
  ports = {
    application_lb_ports = {
      22 = "TCP"
      80 = "HTTP"
    }
    network_lb_ports = {
      22 = "TCP"
      80 = "TCP"
    }
  }
}
