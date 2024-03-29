resource "aws_security_group" "alb_main" {
  name        = "${var.project}-alb"
  description = "${var.project}-alb"
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = false
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    self        = false
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "80"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = false
    to_port          = "80"
  }

  tags = {
    Name = "${var.project}-alb"
  }
}
