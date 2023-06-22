#### Create & associate EIP with MySQL Node

#####################
#### MySQL Node EIP
resource "aws_eip" "mysql_node_eip" {
  count = var.mysql-node-count
  network_border_group = var.region
  domain      = "vpc"

  tags = {
      Name = format("%s-mysql-eip-%s", var.vpc_name, count.index+1),
      Owner = var.owner
  }

}

#### mysql Node Elastic IP association
resource "aws_eip_association" "mysql_eip_assoc" {
  count = var.mysql-node-count
  instance_id   = element(aws_instance.mysql_node.*.id, count.index)
  allocation_id = element(aws_eip.mysql_node_eip.*.id, count.index)
  depends_on    = [aws_instance.mysql_node, aws_eip.mysql_node_eip]
}
