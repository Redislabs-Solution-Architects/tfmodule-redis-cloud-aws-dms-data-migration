#### Outputs

output "dms_mysql_endpoint_source_arn" {
  value = aws_dms_endpoint.dms-endpoint.endpoint_arn
  }

output "replication_instance_arn" {
  value = aws_dms_replication_instance.test.replication_instance_arn
  }

  