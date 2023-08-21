#create vpc
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy     = "default"

  tags = {
    Name = "${var.project}-VPC"
  }
}

#Public Subnets
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 1)
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.project}-sb"
  }
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.project}-IGW"
  }
  depends_on = [aws_vpc.this]
}

# Route Table(s)
# Route the public subnet traffic through the IGW
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.project}-RT"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "internet_access" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.this.id
}