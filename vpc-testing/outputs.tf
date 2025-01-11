output "vpc_id" {
  value = module.testing.vpc_id
}
output "public_subnet_cidr" {
  value = module.testing.public_subnet_cidr
}
output "private_subnet_cidr" {
  value = module.testing.private_subnet_cidr 
}
output "db_subnet_cidr" {
  value = module.testing.db_subnet_cidr 
}
output "db_subnet_group_name" {
  value = module.testing.db_subnet_group_name
}