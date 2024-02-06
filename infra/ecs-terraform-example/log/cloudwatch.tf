resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/ecs/${var.project}-log/nginx"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "php" {
  name              = "/ecs/${var.project}-log/php"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "migration" {
  name              = "/ecs/${var.project}-log/migration"
  retention_in_days = 90
}
