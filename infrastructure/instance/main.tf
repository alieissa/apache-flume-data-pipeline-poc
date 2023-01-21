// TODO Create AMI from aeissa/apache-flume image
// and use here
resource "aws_instance" "etl_prod" {
  ami           = var.ami
  instance_type = var.type

  network_interface {
    network_interface_id = var.private_network_interface_id
    device_index         = 0
  }

  tags = {
    Name = "Apache Flume Agent"
  }
}

resource "aws_instance" "etl_ingest" {
  ami           = var.ami
  instance_type = var.type
  key_name = "Apache Flume Ingestor"

  network_interface {
    network_interface_id = var.public_network_interface_id
    device_index         = 0
  }

  tags = {
    Name = "S3 Data Ingestor"
  }
}