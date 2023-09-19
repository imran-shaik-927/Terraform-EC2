#VPC
resource "aws_vpc" "imranvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "imranvpc"
  }
}
#Public  subnet
resource "aws_subnet" "ecomm-pub-sn" {
  vpc_id     = aws_vpc.imranvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "ecomm-public-subnet"
  }
}
# Private Subnet
resource "aws_subnet" "ecomm-pvt-sn" {
  vpc_id     = aws_vpc.imranvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "ecomm-private-subnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "ecomm-igw" {
  vpc_id = aws_vpc.imranvpc.id

  tags = {
    Name = "ecomm-internet-gateway"
  }
}
#Public-route-table
resource "aws_route_table" "ecomm-pub-rt" {
  vpc_id = aws_vpc.imranvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-igw.id
  }
  tags = {
    Name = "ecomm-public-route-table"
  }
}
# public route table association
resource "aws_route_table_association" "ecomm-pub-asc" {
  subnet_id      = aws_subnet.ecomm-pub-sn.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
}
#Private-route-table
resource "aws_route_table" "ecomm-pvt-rt" {
  vpc_id = aws_vpc.imranvpc.id
  tags = {
    Name = "ecomm-private-route-table"
  }
}
# private route table association
resource "aws_route_table_association" "ecomm-pvt-asc" {
  subnet_id      = aws_subnet.ecomm-pvt-sn.id
  route_table_id = aws_route_table.ecomm-pvt-rt.id
}
#public NACL
resource "aws_network_acl" "ecomm-pub-nacl" {
  vpc_id = aws_vpc.imranvpc.id
  subnet_ids = [aws_subnet.ecomm-pub-sn.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-public-nacl"
  }
}
#private NACL
resource "aws_network_acl" "ecomm-pvt-nacl" {
  vpc_id = aws_vpc.imranvpc.id
  subnet_ids = [aws_subnet.ecomm-pvt-sn.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ecomm-private-nacl"
  }
}
