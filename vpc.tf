resource "aws_vpc" "existing_rstudio_vpc" {
  cidr_block = "10.10.0.0/16"  # Modified CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "existing_rstudio_vpc"
  }
}

resource "aws_subnet" "existing_public_subnet_1" {
  vpc_id                  = aws_vpc.existing_rstudio_vpc.id
  cidr_block              = "10.10.1.0/24"  # Modified CIDR block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "existing_rstudio_public_subnet_1"
  }
}

resource "aws_subnet" "existing_public_subnet_2" {
  vpc_id                  = aws_vpc.existing_rstudio_vpc.id
  cidr_block              = "10.10.2.0/24"  # Modified CIDR block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "existing_rstudio_public_subnet_2"
  }
}

resource "aws_internet_gateway" "existing_rstudio_igw" {
  vpc_id = aws_vpc.existing_rstudio_vpc.id

  tags = {
    Name = "existing_rstudio_igw"
  }
}

resource "aws_route_table" "existing_rstudio_rt" {
  vpc_id = aws_vpc.existing_rstudio_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.existing_rstudio_igw.id
  }
}

resource "aws_route_table_association" "existing_public_assoc" {
  subnet_id      = aws_subnet.existing_public_subnet_1.id
  route_table_id = aws_route_table.existing_rstudio_rt.id
}
