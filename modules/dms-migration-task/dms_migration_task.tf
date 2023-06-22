


resource "aws_dms_replication_task" "example" {
  migration_type            = "full-load"
  replication_instance_arn  = var.replication_instance_arn
  replication_task_id       = "dms-redis-migration-task1"
  source_endpoint_arn       = var.source_endpoint_arn
  target_endpoint_arn       = var.target_endpoint_arn
  #table_mappings = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"example-selection-rule\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"},{\"rule-type\":\"selection\",\"rule-id\":\"2\",\"rule-name\":\"additional-selection-rule\",\"object-locator\":{\"schema-name\":\"tpcds\",\"table-name\":\"web_sales\"},\"rule-action\":\"include\"}]}"
  #replication_task_settings = "{\"TargetMetadata\":{\"TargetTablePrepMode\":\"drop-tables\"},\"FullLoadSettings\":{\"IncludeLobColumns\":true,\"LobChunkSize\":32},\"Logging\":{\"EnableLogging\":true,\"EnableLogTruncation\":true,\"LogComponents\":[{\"Id\":\"data-reload\"},{\"Id\":\"table-statistics\"}]}}"

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

  # replication_task_start_settings {
  #   replication_task_start_type = "start-replication"
  #   #start_task_arn              = ""
  # }

tags = {
    Name = "dms_db_migration_task"
    Owner = "bamos"
  }
}