
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "dms replication subnetgroup"
  replication_subnet_group_id          = "dms-replication-subnetgroup"
  

  subnet_ids = [
    var.vpc_subnets_ids[0],
    var.vpc_subnets_ids[1]
  ]


    tags = {
    Name  = "dms-replication-subnetgroup"
    Owner = "bamos"
  }
}


resource "aws_dms_replication_instance" "test" {
  allocated_storage            = 50
  apply_immediately            = false
  auto_minor_version_upgrade   = false
  availability_zone            = "us-west-2a"
  engine_version               = "3.4.7"
  #kms_key_arn                  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  multi_az                     = false
  #preferred_maintenance_window = "sun:10:30-sun:14:30"
  publicly_accessible          = false
  replication_instance_class   = "dms.t3.large"
  replication_instance_id      = "dms-replication-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id

  tags = {
    Name = "dms-replication-group"
    Owner = "bamos"
  }

  #vpc_security_group_ids = ["sg-12345678"]

  depends_on = [
    aws_dms_replication_subnet_group.dms_subnet_group
  ]
}

# Create a new endpoint
resource "aws_dms_endpoint" "dms-endpoint" {
  #certificate_arn             = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  endpoint_id                 = "dms-source-endpoint"
  endpoint_type               = "source"
  engine_name                 = "mysql"
  extra_connection_attributes = ""
  #kms_key_arn                 = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  server_name              = var.mysql_node_internal-ip[0]
  port                     = 3306
  username                 = "root"
  password                 = "Redis00$"
  ssl_mode                 = "none"

  tags = {
    Name = "dms-source-endpoint"
    Owner = "bamos"
  }
}