
resource "aws_instance" "etl_ingest" {
  ami           = var.ami
  instance_type = var.type
  key_name      = "Apache Flume Ingestor"

  network_interface {
    network_interface_id = var.network_interface
    device_index         = 0
  }

  tags = {
    Name = "S3 Data Ingestor"
  }
}