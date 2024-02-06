resource "aws_lb" "main" {
  name               = var.project
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_main.id]

  drop_invalid_header_fields = false

  subnets = var.subnet_ids

  idle_timeout               = "60"
  enable_deletion_protection = false
  enable_xff_client_port     = true
  enable_http2               = true

  # enable_waf_fail_open
  ip_address_type = "ipv4"

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    enabled = true
    prefix  = var.project
  }


  tags = merge(var.tags, {
    Name = "${var.project}-alb"
  })
}
