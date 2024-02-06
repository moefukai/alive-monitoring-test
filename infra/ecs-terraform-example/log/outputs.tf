output "aws_cloudwatch_log_group_nginx" {
  value = aws_cloudwatch_log_group.nginx.name
}

output "aws_cloudwatch_log_group_php" {
  value = aws_cloudwatch_log_group.php.name
}

output "aws_cloudwatch_log_group_migration" {
  value = aws_cloudwatch_log_group.migration.name
}
