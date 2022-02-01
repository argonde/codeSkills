resource "aws_subnet" "subnet-one" {
  cidr_block              = cidrsubnet(aws_vpc.sandbox.cidr_block, 3, 1)
  vpc_id                  = aws_vpc.sandbox.id
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "route-table-sandbox" {
  vpc_id = aws_vpc.sandbox.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sandbox-gw.id
  }
  tags = {
    Name = "sandbox-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet-one.id
  route_table_id = aws_route_table.route-table-sandbox.id
}
