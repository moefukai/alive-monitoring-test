locals {
  nat_gateway_azs = var.single_nat_gateway ? { keys(var.azs)[0] = values(var.azs)[0] } : var.azs
}

resource "aws_eip" "nat_gateway" {
  for_each = var.enable_nat_gateway ? local.nat_gateway_azs : {}

  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-${each.key}"
  }
}

resource "aws_nat_gateway" "main" {
  for_each      = var.enable_nat_gateway ? local.nat_gateway_azs : {}
  allocation_id = aws_eip.nat_gateway[each.key].id
  subnet_id     = aws_subnet.public_[each.key].id
  tags = merge(var.tags, {
    Name = "${var.project}-nat-${each.key}"
  })
  depends_on = [aws_internet_gateway.main]
}
