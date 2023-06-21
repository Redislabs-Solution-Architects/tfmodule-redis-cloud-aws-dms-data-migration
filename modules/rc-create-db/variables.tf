

variable "rediscloud_subscription_id" {
    description = ""
    default = ""
}

# variable "rc_db_average_item_size_in_bytes" {
#     description = ""
#     default = 0
# }

variable "rc_db_external_endpoint_for_oss_cluster_api" {
    description = ""
    default = false
}

variable "rc_db_data_persistence" {
    description = ""
    default = "none"
}

variable "rc_db_memory_limit_in_gb" {
    description = ""
    default = 1
}

variable "rc_db_name" {
    description = ""
    default = "example-db"
}

variable "rc_db_replication" {
    description = ""
    default = false
}

variable "rc_db_support_oss_cluster_api" {
    description = ""
    default = false
}

variable "rc_db_throughput_measurement_by" {
    description = ""
    default = "operations-per-second"
}

variable "rc_db_throughput_measurement_value" {
    description = ""
    default = 1000
}

variable "rc_db_modules" {
    description = ""
    type        = list(map(string))
    default = [
        {
          "name": "RedisJSON"
        },
        {
          "name": "RedisBloom"
        }
    ]
}