output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_private_a_id" {
  value = aws_subnet.private_["a"].id
}

output "subnet_private_c_id" {
  value = aws_subnet.private_["c"].id
}

output "subnet_private_d_id" {
  value = aws_subnet.private_["d"].id
}

output "subnet_public_a_id" {
  value = aws_subnet.public_["a"].id
}

output "subnet_public_c_id" {
  value = aws_subnet.public_["c"].id
}

output "subnet_public_d_id" {
  value = aws_subnet.public_["d"].id
}
