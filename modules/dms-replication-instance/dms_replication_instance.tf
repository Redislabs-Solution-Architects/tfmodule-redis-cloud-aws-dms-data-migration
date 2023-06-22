
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "dms replication subnetgroup"
  replication_subnet_group_id          = "dms-replication-subnetgroup"
  
  subnet_ids = [
    var.vpc_subnets_ids[0],
    var.vpc_subnets_ids[1]
  ]

  tags = {
    Name = format("%s-dms-replication-subnetgroup", var.prefix_name)
    Owner = var.owner
  }
}


resource "aws_dms_replication_instance" "test" {
  allocated_storage            = 50
  apply_immediately            = false
  auto_minor_version_upgrade   = false
  availability_zone            = var.subnet_azs[0]
  engine_version               = "3.4.7"
  multi_az                     = false
  publicly_accessible          = false
  replication_instance_class   = "dms.t3.large"
  replication_instance_id      = "dms-replication-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id

  tags = {
    Name = format("%s-dms-replication-instance", var.prefix_name)
    Owner = var.owner
  }

  depends_on = [
    aws_dms_replication_subnet_group.dms_subnet_group
  ]
}

# Create a new endpoint
resource "aws_dms_endpoint" "dms-endpoint" {
  endpoint_id                 = "dms-source-endpoint"
  endpoint_type               = "source"
  engine_name                 = "mysql"
  extra_connection_attributes = ""
  server_name                 = var.mysql_node_internal-ip[0]
  port                        = 3306
  username                    = "root"
  password                    = "Redis00$"
  ssl_mode                    = "none"
  
  tags = {
    Name = format("%s-dms-source-endpoint", var.prefix_name)
    Owner = var.owner
  }
}