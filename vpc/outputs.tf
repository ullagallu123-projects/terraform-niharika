output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_id" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "db_subnet_id" {
  value = [for subnet in aws_subnet.db : subnet.id]
}
output "default_vpc_id" {
  value = data.aws_vpc.selected.id
}
