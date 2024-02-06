resource "aws_lb_listener" "https" {
  port            = "443"
  protocol        = "HTTPS"
  certificate_arn = var.certificate_arn

  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
  depends_on = [aws_lb_target_group.http]
}

resource "aws_lb_listener" "redirect_http" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.main.arn

  default_action {
    type  = "redirect"
    order = "1"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
  depends_on = [aws_lb_target_group.http]
}
