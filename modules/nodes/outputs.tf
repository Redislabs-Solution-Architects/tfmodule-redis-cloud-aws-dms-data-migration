#### Outputs

output "mysql-node-eips" {
  value = aws_eip.mysql_node_eip[*].public_ip
}

output "mysql-node-internal-ips" {
  value = aws_instance.mysql_node[*].private_ip
}