resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project}-private"
  })
}

resource "aws_route" "internet_gateway_public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  route_table_id         = aws_route_table.public.id
}
resource "aws_route_table_association" "public" {
  for_each       = var.azs
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_[each.key].id
}

resource "aws_route_table" "private" {
  for_each = var.azs
  vpc_id   = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${var.project}-private-${each.key}"
  })
}

resource "aws_route" "nat_gateway_private" {
  for_each               = var.enable_nat_gateway ? var.azs : {}
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[var.single_nat_gateway ? keys(var.azs)[0] : each.key].id
  route_table_id         = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = var.azs
  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private_[each.key].id
}
