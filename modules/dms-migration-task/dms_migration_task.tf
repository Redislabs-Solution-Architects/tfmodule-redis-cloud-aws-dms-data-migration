


resource "aws_dms_replication_task" "example" {
  migration_type            = "full-load"
  replication_instance_arn  = var.replication_instance_arn
  replication_task_id       = "dms-redis-migration-task"
  source_endpoint_arn       = var.source_endpoint_arn
  target_endpoint_arn       = var.target_endpoint_arn
  table_mappings               = <<EOF
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "my-selection-rule",
      "object-locator": {
        "schema-name": "tpcds",
        "table-name": "web_sales"
      },
      "rule-action": "include"
    }
  ]
}
EOF

  replication_task_settings = <<EOF
{
  "TargetMetadata": {
    "TargetTablePrepMode": "drop-tables"
  },
  "FullLoadSettings": {
    "LimitedSizeLobMode": true,
    "LobChunkSize": 32
  },
  "Logging": {
    "EnableLogging": true,
    "EnableLogTruncation": true
  }
}
EOF

tags = {
    Name = format("%s-dms-migration-task", var.prefix_name)
    Owner = var.owner
  }
}