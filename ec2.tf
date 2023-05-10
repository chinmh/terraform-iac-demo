resource "aws_key_pair" "acntfdemo_key" {
  key_name   = "acntfdemo-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXk66NJU8AEwlcEpnzi8yqHUev1kR/MquFmSAxlm+bCEzQQ2z9liypcXiaA43CSDQrOYud2wRkuy2+hAgMeU4XsKo7Uyjpx4GqFIq7NDDX1h1bA1jlc1vJ7RtJ8mdn/u7frW8ahNlWRo2M2IJeHZyownQ6Dv/k6GERvGRvfOE/V1IIuHa3IYPPaTA5dEq5nMOywhJVDlES0fX4MhREel431phHnGlpEMHDacHRN5fGypxN7lryBxPRO8gJ+UoOtvv818Adbd/zeVQmiUJ4wloT24um2fpmEuIhPrxHTtgcXwO9+VMd7QcNgEg6fQsifyw1DYTQbtGMAne9M7/zWXuf acntfdemo-key"
}

resource "aws_instance" "public_ec2" {
  ami           = "ami-052f483c20fa1351a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_aza.id
  key_name      = aws_key_pair.acntfdemo_key.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  tags = {
    Name = "acntfdemo-public"
  }
}

resource "aws_instance" "private_ec2" {
  ami           = "ami-052f483c20fa1351a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_aza.id
  key_name      = aws_key_pair.acntfdemo_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = {
    Name = "acntfdemo-private"
  }
}

resource "aws_security_group" "public_sg" {
  name = "acntfdemo-public-sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name = "acntfdemo-private-sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}