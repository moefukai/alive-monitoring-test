resource "aws_subnet" "public_" {
  for_each = var.azs

  availability_zone       = "${data.aws_region.current.name}${each.key}"
  cidr_block              = each.value.public_cidr
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project}-private-${each.key}"
  })
}

resource "aws_subnet" "private_" {
  for_each = var.azs

  availability_zone       = "${data.aws_region.current.name}${each.key}"
  cidr_block              = each.value.private_cidr
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project}-private-${each.key}"
  })
}
