resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.project}-database-cluster"

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.1"
  port           = "3306"

  database_name               = var.database_name
  master_username             = var.user_name
  manage_master_user_password = true

  skip_final_snapshot = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
}

resource "aws_rds_cluster_instance" "main" {
  #count = 2
  identifier         = "${var.project}-database-cluster-instance"
  cluster_identifier = aws_rds_cluster.main.id

  engine         = aws_rds_cluster.main.engine
  engine_version = aws_rds_cluster.main.engine_version

  instance_class       = var.node_type
  db_subnet_group_name = aws_rds_cluster.main.db_subnet_group_name
}

resource "aws_rds_cluster_parameter_group" "main" {
  name   = "${var.project}-database-cluster-parameter-group"
  family = "aurora-mysql8.0"

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}
