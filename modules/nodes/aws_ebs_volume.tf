#### Create & attach EBS volumes

resource "aws_ebs_volume" "mysql_node" {
  count             = var.mysql-node-count
  availability_zone = element(var.subnet_azs, count.index)
  size              = var.ebs-volume-size

  tags = {
    Name = format("%s-ec2-mysql-%s", var.vpc_name, count.index+1),
    Owner = var.owner
  }
}

resource "aws_volume_attachment" "mysql_node" {
  count       = var.mysql-node-count
  device_name = "/dev/sdh"
  volume_id   = element(aws_ebs_volume.mysql_node.*.id, count.index)
  instance_id = element(aws_instance.mysql_node.*.id, count.index)
}