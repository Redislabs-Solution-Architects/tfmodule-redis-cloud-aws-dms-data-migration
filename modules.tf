#


########## VPC Module
### create a brand new VPC, use its outputs in future modules
module "aws-vpc" {
    source             = "./modules/aws-vpc"
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region
    prefix_name        = var.prefix_name
    vpc_cidr           = var.vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs         = var.subnet_azs
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids" {
  value = module.aws-vpc.subnet-ids
}

output "vpc-id" {
  value = module.aws-vpc.vpc-id
}

output "vpc_name" {
  description = "get the VPC Name tag"
  value = module.aws-vpc.vpc-name
}

output "route-table-id" {
  description = "route table id"
  value = module.aws-vpc.route-table-id
}


########### Node Module
#### Create MySQL node and install docker and provision a mysql Db in docker.
module "nodes" {
    source             = "./modules/nodes"
    owner              = var.owner
    region             = var.region
    vpc_cidr           = var.vpc_cidr
    subnet_azs         = var.subnet_azs
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    mysql_instance_type = var.mysql_instance_type
    mysql-node-count    = var.mysql-node-count
    ebs-volume-size    = var.ebs-volume-size
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.aws-vpc.vpc-name
    vpc_subnets_ids    = module.aws-vpc.subnet-ids
    vpc_id             = module.aws-vpc.vpc-id
}

#### Node Outputs to use in future modules
output "mysql-node-eips" {
  value = module.nodes.mysql-node-eips
}

output "mysql-node-internal-ips" {
  value = module.nodes.mysql-node-internal-ips
}

########### AWS DMS Module
#### AWS DMS Endpoint Configuration for your source system - MySQL
module "dms-replication-instance" {
    source                  = "./modules/dms-replication-instance"
    owner                   = var.owner
    prefix_name             = var.prefix_name
    subnet_azs              = var.subnet_azs
    ### vars pulled from previous modules
    vpc_subnets_ids         = module.aws-vpc.subnet-ids
    mysql_node_internal-ip  = module.nodes.mysql-node-internal-ips

    depends_on = [
      module.aws-vpc, 
      module.nodes
    ]
}

#outputs
output "replication_instance_arn" {
  value = module.dms-replication-instance.replication_instance_arn
}

output "dms_mysql_endpoint_source_arn" {
  value = module.dms-replication-instance.dms_mysql_endpoint_source_arn
}

############################################ REDIS CLOUD MODULES

######## Redis Cloud Account Information
####### Used in the terraform modules
data "rediscloud_cloud_account" "account" {
  exclude_internal_account = true
  provider_type = "AWS"
}

output "rc_cloud_account_id" {
  value = data.rediscloud_cloud_account.account.id
}

output "rc_cloud_account_provider_type" {
  value = data.rediscloud_cloud_account.account.provider_type
}

output "cloud_account_access_key_id" {
  value = data.rediscloud_cloud_account.account.access_key_id
}

############################ Redis Cloud Subscription
#### Provision an empty (no db) Redis Cloud subscription (1 VPC with 3+ Redis Enterprise Nodes (VMs))
## edit this:
#### The db paramters are used to define the subscription creation plan
#### ie. the size (Size and number of Redis Enterprise Nodes)
module "rc-subscription" {
    source                                = "./modules/rc-subscription"
    rc_cloud_account_id                   = data.rediscloud_cloud_account.account.id
    rc_cloud_account_provider_type        = data.rediscloud_cloud_account.account.provider_type
    rediscloud_subscription_name          = var.rediscloud_subscription_name
    cc_type                               = var.cc_type
    cc_last_4                             = var.cc_last_4
    rc_region                             = var.region
    rc_networking_deployment_cidr         = var.rc_networking_deployment_cidr #MUST BE /24 (MUST NOT OVERLAP WITH AWS Customer VPC CIDR)
    rc_preferred_availability_zones       = var.rc_preferred_availability_zones
    ######### CREATION PLAN (defines the size of cluster, does not deploy a db)
    #### Updating these variables is optional.
    rc_cp_memory_limit_in_gb              = var.rc_cp_memory_limit_in_gb
    rc_cp_quantity                        = var.rc_cp_quantity
    rc_cp_replication                     = var.rc_cp_replication
    rc_cp_support_oss_cluster_api         = var.rc_cp_support_oss_cluster_api
    rc_cp_throughput_measurement_by       = var.rc_cp_throughput_measurement_by
    rc_cp_throughput_measurement_value    = var.rc_cp_throughput_measurement_value
    rc_cp_modules                         = var.rc_cp_modules

    depends_on = [
      data.rediscloud_cloud_account.account
    ]
}

#outputs
# output the Redis Cloud Subscription ID to be used in additional modules
output "rediscloud_subscription_id" {
  value = module.rc-subscription.rediscloud_subscription_id
}

################################## VPC PEERING
############## Redis Cloud VPC peering to Application VPC in AWS account
########## This requires adding a route to the applicaiton VPC in the customers AWS account
module "rc-aws-vpc-peering" {
    source                                  = "./modules/rc-aws-vpc-peering"
    rediscloud_subscription_id              = module.rc-subscription.rediscloud_subscription_id
    aws_customer_application_vpc_region     = var.region
    aws_customer_application_aws_account_id = var.aws_account_id
    aws_customer_application_vpc_id         = module.aws-vpc.vpc-id
    aws_customer_application_vpc_cidr       = var.vpc_cidr
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr
    aws_vpc_route_table_id                  = module.aws-vpc.route-table-id

    depends_on = [
      module.rc-subscription,
      module.aws-vpc
    ]
}

###########
########### Create a Redis Enterprise database in the Redis Cloud Subscription
########### To scale or update the db, simply update the parameters after it has been created.
module "rc-create-db" {
    source                                      = "./modules/rc-create-db"
    rediscloud_subscription_id                  = module.rc-subscription.rediscloud_subscription_id
    rc_db_replication                           = var.rc_db_replication
    rc_db_external_endpoint_for_oss_cluster_api = var.rc_db_external_endpoint_for_oss_cluster_api
    rc_db_support_oss_cluster_api               = var.rc_db_support_oss_cluster_api
    rc_db_throughput_measurement_value          = var.rc_db_throughput_measurement_value
    rc_db_throughput_measurement_by             = var.rc_db_throughput_measurement_by
    rc_db_data_persistence                      = var.rc_db_data_persistence
    rc_db_memory_limit_in_gb                    = var.rc_db_memory_limit_in_gb
    rc_db_name                                  = var.rc_db_name
    rc_db_modules                               = var.rc_db_modules

    depends_on = [
      module.rc-subscription
    ]
}

#outputs
output "redis_db_private_endpoint" {
  value = module.rc-create-db.redis_db_private_endpoint
}


output "redis_db_pw" {
  value = module.rc-create-db.redis_db_pw
  sensitive = true
}


############################################ REDIS CLOUD MODULES (COMPLETE)


########### AWS DMS Target Endpoint Module
#### AWS DMS Endpoint Configuration for your source system - MySQL
module "dms-target-endpoint" {
    source             = "./modules/dms-target-endpoint"
    owner              = var.owner
    prefix_name        = var.prefix_name
    ### vars pulled from previous modules
    redis_db_endpoint  = module.rc-create-db.redis_db_private_endpoint
    redis_db_password  = module.rc-create-db.redis_db_pw

    depends_on = [
      module.dms-replication-instance, 
      module.rc-create-db
    ]
}

#outputs
output "dms_redis_endpoint_target_arn" {
  value = module.dms-target-endpoint.dms_redis_endpoint_target_arn
}

########### AWS DMS Target Endpoint Module
#### AWS DMS Endpoint Configuration for your source system - MySQL
module "dms-migration-task" {
    source                   = "./modules/dms-migration-task"
    owner                    = var.owner
    prefix_name              = var.prefix_name
    ### vars pulled from previous modules
    replication_instance_arn = module.dms-replication-instance.replication_instance_arn
    source_endpoint_arn      = module.dms-replication-instance.dms_mysql_endpoint_source_arn
    target_endpoint_arn      = module.dms-target-endpoint.dms_redis_endpoint_target_arn

    depends_on = [
      module.dms-replication-instance, 
      module.dms-target-endpoint
    ]
}