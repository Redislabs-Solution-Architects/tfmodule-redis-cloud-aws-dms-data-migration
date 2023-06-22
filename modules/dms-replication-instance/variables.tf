#### Required Variables

variable "owner" {
    description = "owner tag name"
}

variable "prefix_name" {
    description = "base name for resources (prefix name)"
    default = "redisuser1-tf"
}

variable "subnet_azs" {
    type = list(any)
    description = "subnet availability zone"
    default = [""]
}

variable "vpc_subnets_ids" {
  type        = list(any)
  description = "The list of subnets available to the VPC"
}

variable "mysql_node_internal-ip" {
    type = list
    description = "."
    default = []
}