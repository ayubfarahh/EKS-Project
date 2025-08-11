output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet" {
  value = [
    aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id
  ]

}