resource "aws_lb_target_group" "http" {
  name                          = "${var.project}-http"
  deregistration_delay          = "300"
  load_balancing_algorithm_type = "round_robin"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"
  target_type                   = "ip"
  vpc_id                        = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = "3"
    interval            = "300"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  tags = merge(var.tags, {
    Name = "${var.project}-alb-target-group"
  })
}

