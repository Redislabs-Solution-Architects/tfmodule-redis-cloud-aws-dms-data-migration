#


########### VPC Module
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
# module "vpc1" {
#     source             = "./modules/vpc"
#     providers = {
#       aws = aws.a
#     }
#     aws_creds          = var.aws_creds
#     owner              = var.owner
#     region             = var.region1
#     base_name          = var.base_name1
#     vpc_cidr           = var.vpc_cidr1
#     subnet_cidr_blocks = var.subnet_cidr_blocks1
#     subnet_azs         = var.subnet_azs1
# }

# ### VPC outputs 
# ### Outputs from VPC outputs.tf, 
# ### must output here to use in future modules)
# output "subnet-ids1" {
#   value = module.vpc1.subnet-ids
# }

# output "vpc-id1" {
#   value = module.vpc1.vpc-id
# }

# output "vpc_name1" {
#   description = "get the VPC Name tag"
#   value = module.vpc1.vpc-name
# }

# output "route-table-id1" {
#   description = "route table id"
#   value = module.vpc1.route-table-id
# }

########## VPC Module
### create a brand new VPC, use its outputs in future modules
### If you already have an existing VPC, comment out and
### enter your VPC params in the future modules
module "aws-vpc" {
    source             = "./modules/aws-vpc"
    # aws_creds          = var.aws_creds
    # owner              = var.owner
    # region             = var.region1 #var.aws_customer_application_vpc_region
    # prefix_name        = var.prefix_name
    # vpc_cidr           = var.aws_customer_application_vpc_cidr
    # subnet_cidr_blocks = var.subnet_cidr_blocks
    # subnet_azs         = var.subnet_azs
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region1
    #base_name          = var.base_name1
    prefix_name         = var.base_name1
    vpc_cidr           = var.vpc_cidr1
    subnet_cidr_blocks = var.subnet_cidr_blocks1
    subnet_azs         = var.subnet_azs1
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
#### Create RE and Test nodes
#### Ansible playbooks configure and install RE software on nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes1" {
    source             = "./modules/nodes"
    # providers = {
    #   aws = aws.a
    # }
    owner              = var.owner
    region             = var.region1
    vpc_cidr           = var.vpc_cidr1
    subnet_azs         = var.subnet_azs1
    ssh_key_name       = var.ssh_key_name1
    ssh_key_path       = var.ssh_key_path1
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
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
output "test-node-eips" {
  value = module.nodes1.test-node-eips
}

output "test-node-internal-ips" {
  value = module.nodes1.test-node-internal-ips
}

# output "re-data-node-eip-public-dns1" {
#   value = module.nodes1.re-data-node-eip-public-dns
# }

########### AWS DMS Module
#### AWS DMS Endpoint Configuration for your source system - MySQL
module "dms-replication-instance" {
    source             = "./modules/dms-replication-instance"
    # providers = {
    #   aws = aws.a
    # }
    ### vars pulled from previous modules
    vpc_subnets_ids         = module.aws-vpc.subnet-ids
    mysql_node_internal-ip  = module.nodes1.test-node-internal-ips

    depends_on = [
      module.aws-vpc, 
      module.nodes1
    ]
}

# #### dns FQDN output used in future modules
# output "dns-ns-record-name1" {
#   value = module.dns1.dns-ns-record-name
# }

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


# ########## VPC Module
# ### create a brand new VPC, use its outputs in future modules
# ### If you already have an existing VPC, comment out and
# ### enter your VPC params in the future modules
# module "aws-vpc" {
#     source             = "./modules/aws-vpc"
#     # aws_creds          = var.aws_creds
#     # owner              = var.owner
#     # region             = var.region1 #var.aws_customer_application_vpc_region
#     # prefix_name        = var.prefix_name
#     # vpc_cidr           = var.aws_customer_application_vpc_cidr
#     # subnet_cidr_blocks = var.subnet_cidr_blocks
#     # subnet_azs         = var.subnet_azs
#     aws_creds          = var.aws_creds
#     owner              = var.owner
#     region             = var.region1
#     #base_name          = var.base_name1
#     prefix_name         = var.base_name1
#     vpc_cidr           = var.vpc_cidr1
#     subnet_cidr_blocks = var.subnet_cidr_blocks1
#     subnet_azs         = var.subnet_azs1
# }

# ### VPC outputs 
# ### Outputs from VPC outputs.tf, 
# ### must output here to use in future modules)
# output "subnet-ids" {
#   value = module.aws-vpc.subnet-ids
# }

# output "vpc-id" {
#   value = module.aws-vpc.vpc-id
# }

# output "vpc_name" {
#   description = "get the VPC Name tag"
#   value = module.aws-vpc.vpc-name
# }

# output "route-table-id" {
#   description = "route table id"
#   value = module.aws-vpc.route-table-id
# }

############################ Redis Cloud Subscription
#### Provision an empty (no db) Redis Cloud subscription (1 VPC with 3+ Redis Enterprise Nodes (VMs))
## edit this:
#### The db paramters are used to define the subscription creation plan
#### ie. the size (Size and number of Redis Enterprise Nodes)
module "rc-subscription" {
    source                          = "./modules/rc-subscription"
    rc_cloud_account_id             = data.rediscloud_cloud_account.account.id
    rc_cloud_account_provider_type  = data.rediscloud_cloud_account.account.provider_type
    rediscloud_subscription_name    = var.rediscloud_subscription_name
    cc_type                         = var.cc_type
    cc_last_4                       = var.cc_last_4
    rc_region                       = var.region1
    rc_networking_deployment_cidr   = var.rc_networking_deployment_cidr #MUST BE /24 (MUST NOT OVERLAP WITH AWS Customer VPC CIDR)
    rc_preferred_availability_zones = var.rc_preferred_availability_zones
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
    # rediscloud_subscription_id              = module.rc-subscription.rediscloud_subscription_id
    # aws_customer_application_vpc_region     = var.aws_customer_application_vpc_region #var.region1 #check
    # aws_customer_application_aws_account_id = var.aws_customer_application_aws_account_id
    # aws_customer_application_vpc_id         = module.aws-vpc.vpc-id #module.vpc1.vpc-id #check
    # aws_customer_application_vpc_cidr       =  var.aws_customer_application_vpc_cidr #var.vpc_cidr1 #check
    # rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr
    # aws_vpc_route_table_id                  =  module.aws-vpc.route-table-id    #module.vpc1.route-table-id #check
    # new
    rediscloud_subscription_id              = module.rc-subscription.rediscloud_subscription_id
    aws_customer_application_vpc_region     = var.region1 #check
    aws_customer_application_aws_account_id = var.aws_customer_application_aws_account_id
    aws_customer_application_vpc_id         = module.aws-vpc.vpc-id #check
    aws_customer_application_vpc_cidr       =  var.vpc_cidr1 #check
    rc_networking_deployment_cidr           = var.rc_networking_deployment_cidr
    aws_vpc_route_table_id                  =  module.aws-vpc.route-table-id #check

    depends_on = [
      #module.vpc1, 
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

############################################ REDIS CLOUD MODULES (COMPLETE)