
#### Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support          = true
  enable_dns_hostnames        = true

  tags = {
    Name = format("%s-%s-vpc", var.prefix_name, var.region),
    Project = format("%s-%s", var.prefix_name, var.region),
    Owner = var.owner
  }
}


#### Create the subnets
resource "aws_subnet" "subnets" {
  for_each = zipmap(var.subnet_cidr_blocks, var.subnet_azs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.key
  availability_zone = each.value
  tags = {
    Name = format("%s-subnet-%s", var.prefix_name, each.key)
  }
}


#### network
#### Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-igw", var.prefix_name),
    Project = format("%s-%s", var.prefix_name, var.region),
    Owner = var.owner
    }
}

#### Create the default route table
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    Name = format("%s-rt", var.prefix_name),
    Project = format("%s-%s", var.prefix_name, var.region),
    Owner = var.owner
  }
}

#### Associate the subnets with the default route table
resource "aws_route_table_association" "subnet_route_table_associations" {
  for_each = aws_subnet.subnets
  subnet_id = each.value.id
  route_table_id = aws_default_route_table.route_table.id
}