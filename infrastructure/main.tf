// TODO Move network resources config to own module
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_vpc" "etl" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Data Ingestion"
  }
}

resource "aws_subnet" "etl_private" {
  vpc_id     = aws_vpc.etl.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Data Ingestion - Private"
  }
}

resource "aws_subnet" "etl_public" {
  vpc_id                  = aws_vpc.etl.id
  cidr_block              = "10.0.2.0/24"
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

// TODO Create AMI from aeissa/apache-flume image
// and use here
resource "aws_instance" "etl_prod" {
  ami           = "ami-0039da1f3917fa8e3"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.etl_private.id
    device_index         = 0
  }

  tags = {
    Name = "Apache Flume Agent"
  }
}

resource "aws_instance" "etl_ingest" {
  ami           = "ami-0039da1f3917fa8e3"
  instance_type = "t2.micro"
  key_name = "Apache Flume Ingestor"

  network_interface {
    network_interface_id = aws_network_interface.etl_public.id
    device_index         = 0
  }

  tags = {
    Name = "S3 Data Ingestor"
  }
}