####################
# VPC Configuration
####################
# create vpc
resource "aws_vpc" "vpc" {
    tags = {
      "Name" = "uda-movies"
    }
  
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id  
}

# create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.public_az
  map_public_ip_on_launch = true
  tags = {
    "Name" = "uda-movies-public"
  }
}

# create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "public"
  }
}

# associate the route table
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

# create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.private_az
  tags = {
    "Name" = "uda-movies-private"
  }   
}
# create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "private"
  }
}

# Associate private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}


