resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_ap_south_1a.id

  tags = {
    Name = "Test-NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}
