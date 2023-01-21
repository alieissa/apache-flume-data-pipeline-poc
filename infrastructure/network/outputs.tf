output "id" {
  value = aws_vpc.etl.id
}

output "private_network_interface_id" {
  value = aws_network_interface.etl_private.id
}

output "public_network_interface_id" {
  value = aws_network_interface.etl_public.id
}