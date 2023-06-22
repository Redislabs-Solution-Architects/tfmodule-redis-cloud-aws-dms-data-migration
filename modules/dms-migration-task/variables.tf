#### Required Variables

variable "owner" {
    description = "owner tag name"
}

variable "prefix_name" {
    description = "base name for resources (prefix name)"
    default = "redisuser1-tf"
}

variable "source_endpoint_arn" {
  description = ""
}

variable "target_endpoint_arn" {
  description = ""
}


variable "replication_instance_arn" {
  description = ""
}