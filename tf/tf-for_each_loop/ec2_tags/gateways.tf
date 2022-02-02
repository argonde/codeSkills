resource "aws_internet_gateway" "sandbox-gw" {
  vpc_id = aws_vpc.sandbox.id
  tags = {
    Name = "sandbox-gw"
  }
}
