terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.public_subnet1_az
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = local.tags

}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = var.public_subnet2_az
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = local.tags

}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.private_subnet1_az
  tags              = local.tags

}


resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.private_subnet2_az
  tags              = local.tags
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.igw_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.tags
}

resource "aws_route_table_association" "rta_pub1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "rta_pub2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet2.id

}

resource "aws_eip" "elastic_ip" {
  domain     = var.eip_domain
  depends_on = [aws_internet_gateway.igw]
  tags       = local.tags
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_eip.elastic_ip]
  tags          = local.tags

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.igw_cidr
    nat_gateway_id = aws_nat_gateway.ngw.id

  }
  tags = local.tags
}

resource "aws_route_table_association" "rta_priv1" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet1.id

}

resource "aws_route_table_association" "rta_priv2" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet2.id

}