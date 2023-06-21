# ##### Subscription Peering

variable "aws_customer_application_vpc_region" {
    description = "aws_customer_application_vpc_region"
}

variable "aws_customer_application_aws_account_id" {
    description = "aws_customer_application_aws_account_id"
}

variable "aws_customer_application_vpc_id" {
    description = "aws_customer_application_vpc_id"
}

variable "aws_customer_application_vpc_cidr" {
    description = "aws_customer_application_vpc_cidr"
}

variable "aws_vpc_route_table_id" {
    description = "aws_customer_application_vpc_cidr"
}

variable "rc_networking_deployment_cidr" {
    description = "the CIDR of your RedisCloud deployment"
}

variable "rediscloud_subscription_id" {
    description = "the CIDR of your RedisCloud deployment"
}