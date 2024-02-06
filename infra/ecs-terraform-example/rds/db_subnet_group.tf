resource "aws_db_subnet_group" "main" {
  name = "${var.project}-rds-subnet-group"

  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project}-rds-subnet-group"
  }
}
