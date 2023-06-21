

variable "cc_type" {
    description = "credit card type"
    default = "Visa"
}

variable "cc_last_4" {
    description = "Last 4 digits for payment method"
}

variable "rediscloud_subscription_name" {
    description = "Name of RedisCloud subscription"
}

variable "rc_cloud_account_id" {
    description = "rediscould account id"
    default = ""
}

variable "rc_cloud_account_provider_type" {
    description = "rc_cloud_account_provider_type"
    default = "AWS"
}
##### Redis Cloud Subscription Variables

variable "rc_region" {
    description = ""
}

variable "rc_networking_deployment_cidr" {
    description = "the CIDR of your RedisCloud deployment"
}

variable "rc_preferred_availability_zones" {
    description = ""
    type        = list(any)
}

variable "rc_memory_storage" {
    description = "ram"
    default = "ram"
}

##### Redis Cloud Creation Plan Variables
##### The Creation plan defines the infra for the RE Subscription Cluster, it does not deploy a db.
# variable "rc_cp_average_item_size_in_bytes" {
#     description = "Relevant only to ram-and-flash clusters. Estimated average size (measured in bytes) of the items stored in the database. The value needs to be the maximum average item size defined in one of your databases."
#     default = 1
# }

variable "rc_cp_memory_limit_in_gb" {
    description = "Maximum memory usage that will be used for your largest planned database."
    default = 25
}

variable "rc_cp_quantity" {
    description = "The planned number of databases in the subscription."
    default = 1
}

variable "rc_cp_replication" {
    description = "Databases replication. Set to true if any of your databases will use replication."
    default = true
}

variable "rc_cp_support_oss_cluster_api" {
    description = "Support Redis open-source (OSS) Cluster API."
    default = false
}

variable "rc_cp_throughput_measurement_by" {
    description = "Throughput measurement method that will be used by your databases, (either 'number-of-shards' or 'operations-per-second')"
    default = "operations-per-second"
}

variable "rc_cp_throughput_measurement_value" {
    description = "Throughput value that will be used by your databases (as applies to selected measurement method). The value needs to be the maximum throughput measurement value defined in one of your databases."
    default = 12000
}

variable "rc_cp_modules" {
    description = "a list of modules that will be used by the databases in this subscription. Not currently compatible with 'ram-and-flash' memory storage."
    type        = list(any)
    default = ["RedisJSON"]
}
