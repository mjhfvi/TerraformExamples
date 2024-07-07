resource "aws_lb" "main" {
  count              = var.create_lb ? 1 : 0
  name               = "${var.configure_lb}-lb-main-${var.customer_name}"
  internal           = false
  load_balancer_type = var.configure_lb
  security_groups    = [aws_security_group.sg["http"].id, aws_security_group.sg["https"].id, aws_security_group.sg["ssh"].id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id, aws_subnet.public_subnets[2].id]

  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_log_bucket[0].id
  #   prefix  = "logs-lb"
  #   enabled = true
  # }
}

########### Application Load Balancer Configuration ###########
#### Target Groups
resource "aws_lb_target_group" "alb_target_group_http" {
  count    = var.configure_lb == "application" ? 1 : 0
  name     = "lb-target-group-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

#### Listeners
resource "aws_lb_listener" "alb_listener_http" {
  count             = var.configure_lb == "application" ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_http[0].arn
  }
}

# resource "aws_lb_listener" "alb_listener_https" {
#   count             = var.configure_lb == "application" ? 1 : 0
#   load_balancer_arn = aws_lb.main[0].arn
#   port              = "443"
#   protocol          = "HTTPS"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group_http[0].arn
#   }
# }

########### Network Load Balancer Configuration ###########
#### Target Groups
resource "aws_lb_target_group" "nlb_target_group_http" {
  count    = var.configure_lb == "network" ? 1 : 0
  name     = "lb-target-group-http"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "nlb_target_group_ssh" {
  count    = var.configure_lb == "network" ? 1 : 0
  name     = "lb-target-group-ssh"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

#### Listeners
resource "aws_lb_listener" "nlb_listener_http" {
  count             = var.configure_lb == "network" ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group_http[0].arn
  }
}

# resource "aws_lb_listener" "nlb_listener_https" {
#   load_balancer_arn = aws_lb.main[0].arn
#   port              = "443"
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group_http.arn
#   }
# }

resource "aws_lb_listener" "nlb_listener_ssh" {
  count             = var.configure_lb == "network" ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group_ssh[0].arn
  }
}

#### Target Group Register Instances Allocation Only
resource "aws_lb_target_group_attachment" "attachment_ssh_frontend_a" {
  count            = var.configure_lb == "network" ? 1 : 0
  target_group_arn = aws_lb_target_group.nlb_target_group_ssh[0].arn
  target_id        = aws_instance.frontend["frontend_a"].id
  port             = 22
}

resource "aws_lb_target_group_attachment" "attachment_ssh_frontend_b" {
  count            = var.configure_lb == "network" ? 1 : 0
  target_group_arn = aws_lb_target_group.nlb_target_group_ssh[0].arn
  target_id        = aws_instance.frontend["frontend_b"].id
  port             = 22
}

########### Target Group Register Instances Both Network and Application ###########
resource "aws_lb_target_group_attachment" "nlb_attachment_http_frontend_a" {
  count            = var.configure_lb == "network" ? 1 : 0
  target_group_arn = aws_lb_target_group.nlb_target_group_http[0].arn
  target_id        = aws_instance.frontend["frontend_a"].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "nlb_attachment_http_frontend_b" {
  count            = var.configure_lb == "network" ? 1 : 0
  target_group_arn = aws_lb_target_group.nlb_target_group_http[0].arn
  target_id        = aws_instance.frontend["frontend_b"].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "alb_attachment_http_frontend_a" {
  count            = var.configure_lb == "application" ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_target_group_http[0].arn
  target_id        = aws_instance.frontend["frontend_a"].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "alb_attachment_http_frontend_b" {
  count            = var.configure_lb == "application" ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_target_group_http[0].arn
  target_id        = aws_instance.frontend["frontend_b"].id
  port             = 80
}
