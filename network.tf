resource "aws_vpc" "vpc_workspace" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "Workspace"
    "Goal" = "Study"
  }
}

resource "aws_internet_gateway" "Internet_Access" {
  vpc_id = aws_vpc.vpc_workspace.id

  tags = {
    "Name" = "Internet Access"
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_workspace.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"    = "Public Subnet"
    "Network" = "Open"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc_workspace.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    "Name"    = "Private Subnet"
    "Network" = "Closed"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_workspace.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Access.id
  }
  tags = {
    "Name" = "Public route table for internet access"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}