# Create VPC
resource "aws_vpc" "test-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Test VPC"
  }
}

# data "aws_availability_zones" "available" {}

# Create subnets
# resource "aws_subnet" "public" {
#   vpc_id                  = aws_vpc.test-vpc.id
#   cidr_block              = "10.0.1.0/24"

#   availability_zone       = "us-east-1a"

#   map_public_ip_on_launch = "true"

#   tags = {
#     Name = "test_public_subnet"
#   }
# }

resource "aws_subnet" "public" {
  count             = length(var.subnet_cidr_public)
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = var.subnet_cidr_public[count.index]
  availability_zone = var.availability_zone_public[count.index]
  tags = {
    "Name" = "Application-1-public"
  }

}
# resource "aws_subnet" "private" {
#  vpc_id = "${aws_vpc.test-vpc.id}"
#  cidr_block = "10.0.2.0/24"
#  availability_zone = "us-east-1b"

#  tags = {
#   Name = "test_private_subnet"
#  }
# }

resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = var.availability_zone_private[count.index]
  tags = {
    "Name" = "Application-1-private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "TEST VPC IG"
  }
}

# Create Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Route Table for aws service"
  }
}

# Associating Public and Private Subnets to the Route Table
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.rt.id
# }

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidr_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}
# resource "aws_route_table_association" "b" {
#  subnet_id = "${aws_subnet.private.id}"
#  route_table_id = "${aws_route_table.rt.id}"
# }

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidr_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}