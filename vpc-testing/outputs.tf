output "vpc_id" {
  value = module.testing.vpc_id
}
output "public_subnet_id" {
  value = module.testing.public_subnet_id
}
output "private_subnet_id" {
  value = module.testing.private_subnet_id
}
output "db_subnet_id" {
  value = module.testing.db_subnet_id
}
output "db_subnet_group_name" {
  value = module.testing.db_subnet_group
}