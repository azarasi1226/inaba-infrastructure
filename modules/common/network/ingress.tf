resource "aws_subnet" "ingress" {
  count = length(var.ingress_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.ingress_subnets[count.index].cidr
  availability_zone       = var.ingress_subnets[count.index].az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-ingress-subnet-${count.index}"
  }
}

resource "aws_route_table" "ingress" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "ingress" {
  count = length(aws_subnet.ingress)

  route_table_id = aws_route_table.ingress.id
  subnet_id      = aws_subnet.ingress[count.index].id
}