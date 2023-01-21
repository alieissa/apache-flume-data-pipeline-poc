
resource "aws_vpc" "etl" {
  cidr_block = var.cidr

  tags = {
    Name = "Data Ingestion"
  }
}

resource "aws_subnet" "etl_private" {
  vpc_id     = aws_vpc.etl.id
  cidr_block = var.private_cidr

  tags = {
    Name = "Data Ingestion - Private"
  }
}

resource "aws_subnet" "etl_public" {
  vpc_id                  = aws_vpc.etl.id
  cidr_block              = var.public_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Data Ingestion - Public"
  }
}

resource "aws_network_interface" "etl_private" {
  subnet_id = aws_subnet.etl_private.id

  tags = {
    Name = "Data Ingestion Subnet Interface - Private"
  }
}

resource "aws_network_interface" "etl_public" {
  subnet_id = aws_subnet.etl_public.id

  security_groups = [aws_security_group.etl_ssh.id]

  depends_on = [
    aws_security_group.etl_ssh
  ]
  tags = {
    Name = "Data Ingestion Subnet Interface - Public"
  }
}

resource "aws_internet_gateway" "etl_igw" {
  vpc_id = aws_vpc.etl.id

  tags = {
    Name = "Data Ingestion IGW"
  }
}

resource "aws_route_table" "etl_rt" {
  vpc_id = aws_vpc.etl.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.etl_igw.id
  }
}

resource "aws_route_table_association" "etl_rta" {
  subnet_id      = aws_subnet.etl_public.id
  route_table_id = aws_route_table.etl_rt.id
}

resource "aws_security_group" "etl_ssh" {
  vpc_id = aws_vpc.etl.id

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}