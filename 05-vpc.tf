# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "us-east-1c"
}







# # Create VPC
# resource "aws_vpc" "default" {
#   cidr_block = "10.0.0.0/16"
#   instance_tenancy = "default"
#   enable_dns_hostnames = "true"

#   tags = {
#     Name = "Test VPC"
#   }
# }

# # Create subnets
# resource "aws_subnet" "public" {
#   count                   = 2
#   cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, 2 + count.index)
#   availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
#   vpc_id                  = aws_vpc.default.id
#   map_public_ip_on_launch = true
# }
# resource "aws_subnet" "private" {
#   count             = 2
#   cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
#   availability_zone = data.aws_availability_zones.available_zones.names[count.index]
#   vpc_id            = aws_vpc.default.id
# }

# # Internet Gateway
# resource "aws_internet_gateway" "gateway" {
#   vpc_id = aws_vpc.default.id
# }

# # Create AWS Route
# resource "aws_route" "internet_access" {
#   route_table_id         = aws_vpc.default.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.gateway.id
# }

# # Create EIP 
# resource "aws_eip" "gateway" {
#   count      = 2
#   vpc        = true
#   depends_on = [aws_internet_gateway.gateway]
# }

# # Create NAT gateway
# resource "aws_nat_gateway" "gateway" {
#   count         = 2
#   subnet_id     = element(aws_subnet.public.*.id, count.index)
#   allocation_id = element(aws_eip.gateway.*.id, count.index)
# }

# # Create Route Table
# resource "aws_route_table" "public" {
#   count  = 2
#   vpc_id = aws_vpc.default.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = element(aws_internet_gateway.gateway.*.id, count.index)
#   }
# }

# resource "aws_route_table" "private" {
#   count  = 2
#   vpc_id = aws_vpc.default.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = element(aws_internet_gateway.gateway.*.id, count.index)
#   }
# } 

# # Associating Private Subnet to the Route Table
# resource "aws_route_table_association" "private" {
#   count          = 2
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
#   route_table_id = element(aws_route_table.private.*.id, count.index)
# }

# resource "aws_route_table_association" "public" {
#   count          = 2
#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = element(aws_route_table.public.*.id, count.index)
# }
