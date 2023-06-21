

// The primary database to provision
resource "rediscloud_subscription_database" "example" {
    subscription_id                       = var.rediscloud_subscription_id
    name                                  = var.rc_db_name
    protocol                              = "redis"
    memory_limit_in_gb                    = var.rc_db_memory_limit_in_gb
    data_persistence                      = var.rc_db_data_persistence
    throughput_measurement_by             = var.rc_db_throughput_measurement_by
    throughput_measurement_value          = var.rc_db_throughput_measurement_value
    support_oss_cluster_api               = var.rc_db_support_oss_cluster_api
    external_endpoint_for_oss_cluster_api = var.rc_db_external_endpoint_for_oss_cluster_api
    replication                           = var.rc_db_replication
    modules = var.rc_db_modules

    # alert {
    #   name = "dataset-size"
    #   value = 40
    # }

}