resource "aws_vpc" "imranvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "imranvpc"
  }
}
resource "aws_subnet" "imransubnet" {
  vpc_id     = aws_vpc.imranvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "imransubnet"
  }
}
resource "aws_internet_gateway" "imranig" {
  vpc_id = aws_vpc.imranvpc.id

  tags = {
    Name = "imranig"
  }
}
resource "aws_route_table" "imranrt" {
  vpc_id = aws_vpc.imranvpc.id

  tags = {
    Name = "imranrt"
  }
}
resource "aws_route_table_association" "imranrta" {
  subnet_id      = aws_subnet.imransubnet.id
  route_table_id = aws_route_table.imranrt.id
}
resource "aws_network_acl" "imrannacl" {
  vpc_id = aws_vpc.imranvpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "imrannacl"
  }
}
resource "aws_network_acl_association" "imrannacla" {
  network_acl_id = aws_network_acl.imrannacl.id
  subnet_id      = aws_subnet.imransubnet.id
}