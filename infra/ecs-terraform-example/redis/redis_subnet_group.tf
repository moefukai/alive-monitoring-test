resource "aws_elasticache_subnet_group" "main" {
  description = "${var.project}-redis-subnet-group"
  name        = "${var.project}-redis-subnet-group"
  subnet_ids  = var.subnet_ids
}
