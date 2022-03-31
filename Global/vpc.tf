#Custom VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.cidr
  #   enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-ecs-vpc"
  }
}

#Public subnets created in two AZs
resource "aws_subnet" "public_subnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = var.azs[count.index]
  cidr_block              = var.public_subnets_ip[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-public-subnets"
  }
}

#Private subnets created in two AZs
resource "aws_subnet" "private_subnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.ecs_vpc.id
  availability_zone       = var.azs[count.index]
  cidr_block              = var.private_subnets_ip[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-private-subnets"
  }
}

#Internet Gateway to connect public internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

#Public Subnets Route Table
resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.ecs_vpc.id
}

#All Request from public subnet Routing to IGW
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#Public subnet association with route table
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.azs)
  route_table_id = aws_route_table.public_table.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}
/*
Two seperate route table for each private subnet. Each private subnet points to different nat gateway to have
highly reselient NAT
*/
resource "aws_route_table" "private_table" {
  count  = length(var.azs)
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "${var.prefix}-privateable-${count.index}"
  }
}

resource "aws_route" "private_route" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat[count.index].id
}


resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.azs)
  route_table_id = aws_route_table.private_table[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  allocation_id = aws_eip.ip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.prefix}-nat-${count.index}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Elastic IP for NAT
resource "aws_eip" "ip" {
  count = length(var.azs)
  vpc   = true
}
