#### Required Variables


variable "vpc_subnets_ids" {
  type        = list(any)
  description = "The list of subnets available to the VPC"
}

variable "mysql_node_internal-ip" {
    type = list
    description = "."
    default = []
}