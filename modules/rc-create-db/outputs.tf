

# output "redis_db_private_endpoint" {
#   description = "redis_db_private_endpoint"
#   value = rediscloud_subscription_database.example.private_endpoint
# }

locals {
  original_endpoint = rediscloud_subscription_database.example.private_endpoint
  endpoint_parts = split(":", local.original_endpoint)
  modified_endpoint = join(":", slice(local.endpoint_parts, 0, length(local.endpoint_parts) - 1))
}

output "redis_db_private_endpoint" {
  value = local.modified_endpoint
}

output "redis_db_pw" {
  description = "redis db password"
  value = rediscloud_subscription_database.example.password
  sensitive = true
}