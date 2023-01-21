output "id" {
  value = aws_vpc.etl.id
}

output "network_interface" {
  value = {
    private = aws_network_interface.etl_private.id
    public  = aws_network_interface.etl_public.id
  }
}