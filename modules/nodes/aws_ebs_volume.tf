#### Create & attach EBS volumes for RE nodes

# Attach Persistent Volumes
# Instance 1
resource "aws_ebs_volume" "mysql_node" {
  count             = var.test-node-count
  availability_zone = element(var.subnet_azs, count.index)
  size              = var.ebs-volume-size

  tags = {
    Name = format("%s-ec2-mysql-%s", var.vpc_name, count.index+1),
    Owner = var.owner
  }
}

resource "aws_volume_attachment" "mysql_node" {
  count       = var.test-node-count
  device_name = "/dev/sdh"
  volume_id   = element(aws_ebs_volume.mysql_node.*.id, count.index)
  instance_id = element(aws_instance.test_node.*.id, count.index)
}