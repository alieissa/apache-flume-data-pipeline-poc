
resource "aws_vpc" "etl" {
  cidr_block = var.cidr

  tags = {
    Name = "Data Ingestion"
  }
}

resource "aws_subnet" "etl" {
  vpc_id                  = aws_vpc.etl.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Data Ingestion"
  }
}

resource "aws_network_interface" "etl" {
  subnet_id = aws_subnet.etl.id

  security_groups = [aws_security_group.etl.id]
  private_ips     = [var.instance_ip]

  depends_on = [
    aws_security_group.etl
  ]
  tags = {
    Name = "Data Ingestion Subnet Interface"
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
  subnet_id      = aws_subnet.etl.id
  route_table_id = aws_route_table.etl_rt.id
}

// Terraform documentation says only
// from_port, to_port and protocol fields
// are required, but cannot validate
// a plan without the other fields
resource "aws_security_group" "etl" {
  vpc_id = aws_vpc.etl.id

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}