resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = [
    aws_subnet.private_["a"].id,
    aws_subnet.private_["c"].id,
    aws_subnet.private_["d"].id,
  ]

  tags = merge(var.tags, { "Name" = "${var.project}" })
}
