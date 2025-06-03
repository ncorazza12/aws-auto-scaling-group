# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Public Subnets, Public Route Table and Public Route Table Associations
resource "aws_subnet" "sn_pub_az1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = var.sn_pub_az1a_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sn_pub_az1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1c"
  cidr_block              = var.sn_pub_az1c_cidr
  map_public_ip_on_launch = true
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_pub_sn_pub_az1a" {
  subnet_id      = aws_subnet.sn_pub_az1a.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "rt_pub_sn_pub_az1c" {
  subnet_id      = aws_subnet.sn_pub_az1c.id
  route_table_id = aws_route_table.rt_pub.id
}

# NAT Gateways
resource "aws_eip" "nat_eip_pub_az1a" {}

resource "aws_eip" "nat_eip_pub_az1c" {}

resource "aws_nat_gateway" "nat_gw_pub_az1a" {
  allocation_id = aws_eip.nat_eip_pub_az1a.id
  subnet_id     = aws_subnet.sn_pub_az1a.id
}

resource "aws_nat_gateway" "nat_gw_pub_az1c" {
  allocation_id = aws_eip.nat_eip_pub_az1c.id
  subnet_id     = aws_subnet.sn_pub_az1c.id
}

# Private Subnets, NAT Gateways, Route Table and Route Table Associations
resource "aws_subnet" "sn_priv_az1a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = var.sn_priv_az1a_cidr
}

resource "aws_subnet" "sn_priv_az1c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1c"
  cidr_block        = var.sn_priv_az1c_cidr
}

resource "aws_route_table" "rt_priv_az1a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_pub_az1a.id
  }
}

resource "aws_route_table" "rt_priv_az1c" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_pub_az1c.id
  }
}

resource "aws_route_table_association" "rt_priv_az1a_sn_priv_az1a" {
  subnet_id      = aws_subnet.sn_priv_az1a.id
  route_table_id = aws_route_table.rt_priv_az1a.id
}

resource "aws_route_table_association" "rt_priv_az1c_sn_priv_az1c" {
  subnet_id      = aws_subnet.sn_priv_az1c.id
  route_table_id = aws_route_table.rt_priv_az1c.id
}