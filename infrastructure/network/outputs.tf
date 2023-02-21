output "id" {
  value = aws_vpc.etl.id
}

output "network_interface" {
  value = aws_network_interface.etl.id
}

output "subnet_id" {
  value = aws_subnet.etl.id
}

output "security_group_id" {
  value = aws_security_group.etl.id
}