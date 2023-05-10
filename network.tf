/* VPC */
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "acntfdemo-vpc"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "acntfdemo-igw"
  }
}

/* Public route table */
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "acntfdemo-public-route-table"
  }
}

/* Add internet gateway to public route table */
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

/* Public subnet */
resource "aws_subnet" "public_subnet_aza" {
  cidr_block              = "10.0.0.0/20"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  
  tags = {
    Name        = "acntfdemo-public-aza"
  }
}

resource "aws_subnet" "public_subnet_azb" {
  cidr_block              = "10.0.16.0/20"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false
  
  tags = {
    Name        = "acntfdemo-public-azb"
  }
}

/* Public Route Table Association */
resource "aws_route_table_association" "public_aza" {
  subnet_id      = aws_subnet.public_subnet_aza.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_azb" {
  subnet_id      = aws_subnet.public_subnet_azb.id
  route_table_id = aws_route_table.public_rt.id
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "acntfdemo-nat-eip"
  }
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_aza.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "acntfdemo-nat"
  }
}

/* Private Network*/
/* Private route table */
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "acntfdemo-private-route-table"
  }
}

/* Add nat gateway to private route table */
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Private subnet */
resource "aws_subnet" "private_subnet_aza" {
  cidr_block              = "10.0.128.0/20"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  
  tags = {
    Name        = "acntfdemo-private-aza"
  }
}

resource "aws_subnet" "private_subnet_azb" {
  cidr_block              = "10.0.144.0/20"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false
  
  tags = {
    Name        = "acntfdemo-private-azb"
  }
}

/* Private Route Table Association */
resource "aws_route_table_association" "private_aza" {
  subnet_id      = aws_subnet.private_subnet_aza.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_azb" {
  subnet_id      = aws_subnet.private_subnet_azb.id
  route_table_id = aws_route_table.private_rt.id
}


/* EIP for public ec2 and association*/
resource "aws_eip" "ec2_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "acntfdemo-ec2-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.public_ec2.id
  allocation_id = aws_eip.ec2_eip.id
}