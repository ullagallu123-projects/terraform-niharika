### Locals
locals {
  name = "${var.environment}-${var.project_name}"
}

### Data Block
data "aws_vpc" "selected" {
  default = true
}

### VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}

### IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )

}

### Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${local.name}-public-${split("-", var.azs[count.index])[2]}"
    },
    var.common_tags
  )
}

### Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    {
      Name = "${local.name}-private-${split("-", var.azs[count.index])[2]}"
    },
    var.common_tags
  )
}

### DB subnets
resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    {
      Name = "${local.name}-db-${split("-", var.azs[count.index])[2]}"
    },
    var.common_tags
  )
}

resource "aws_db_subnet_group" "default" {
  name       = local.name
  subnet_ids = aws_subnet.db[*].id

  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}

### Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${local.name}-public-rt"
    },
    var.common_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${local.name}-private-rt"
    },
    var.common_tags
  )
}
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "${local.name}-db-rt"
    },
    var.common_tags
  )
}
### Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db" {
  count          = length(aws_subnet.db)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}

### NAT Gateway
resource "aws_eip" "eip" {
  count  = var.enable_nat ? 1 : 0
  domain = "vpc"
  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}

resource "aws_nat_gateway" "example" {
  count         = var.enable_nat ? 1 : 0
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
  depends_on = [aws_internet_gateway.gw]
}

### Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "private" {
  count                  = var.enable_nat ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example[count.index].id
}

resource "aws_route" "db" {
  count                  = var.enable_nat ? 1 : 0
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example[count.index].id
}

### VPC Peering
resource "aws_vpc_peering_connection" "foo" {
  count= var.vpc_peering_enable ? 1 : 0
  peer_vpc_id = data.aws_vpc.selected.id
  vpc_id      = aws_vpc.main.id
  auto_accept = true
  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}


resource "aws_route" "public_peering" {
  count= var.vpc_peering_enable ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.selected.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo[count.index].id
}

resource "aws_route" "private_peering" {
  count= var.vpc_peering_enable ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.selected.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo[count.index].id
}


resource "aws_route" "db_peering" {
  count= var.vpc_peering_enable ? 1 : 0
  route_table_id            = aws_route_table.db.id
  destination_cidr_block    = data.aws_vpc.selected.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo[count.index].id
}

resource "aws_route" "default_vpc_route_peering" {
  count= var.vpc_peering_enable ? 1 : 0
  route_table_id            = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo[count.index].id
}



