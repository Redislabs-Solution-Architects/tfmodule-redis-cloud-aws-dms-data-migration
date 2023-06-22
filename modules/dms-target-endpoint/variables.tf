#### Required Variables

variable "owner" {
    description = "owner tag name"
}

variable "prefix_name" {
    description = "base name for resources (prefix name)"
    default = "redisuser1-tf"
}

variable "redis_db_password" {
  description = ""
}

variable "redis_db_endpoint" {
  description = ""
}