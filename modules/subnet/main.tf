resource "aws_subnet" "private" {
  vpc_id     = var.vpc_id
  cidr_block = var.pri_sub_cidr

  tags = {
    Name = "${var.project}-private-subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.pub_sub_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.project}-NAT"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.project}-public-RT"
  }
}

resource "aws_route_table_association" "tr-as" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table" "rt-1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project}-private-RT"
  }
}

resource "aws_route_table_association" "rt-nat" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt-1.id
}
