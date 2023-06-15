#


########### VPC Module
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "vpc1" {
    source             = "./modules/vpc"
    providers = {
      aws = aws.a
    }
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region1
    base_name          = var.base_name1
    vpc_cidr           = var.vpc_cidr1
    subnet_cidr_blocks = var.subnet_cidr_blocks1
    subnet_azs         = var.subnet_azs1
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids1" {
  value = module.vpc1.subnet-ids
}

output "vpc-id1" {
  value = module.vpc1.vpc-id
}

output "vpc_name1" {
  description = "get the VPC Name tag"
  value = module.vpc1.vpc-name
}

output "route-table-id1" {
  description = "route table id"
  value = module.vpc1.route-table-id
}

# ######
# #### VPC Peering Modules
# #### VPC peering is broken into 2 modules because you need to 
# #### request from region A (provider A), and accept from region B (provider B)
# #### Final step is to do a route table association to the VPC peering ID

# #### VPC peering requestor from region A (VPC A) to region B (VPC B)
# module "vpc-peering-requestor" {
#     source             = "./modules/vpc-peering-requestor"
#     providers = {
#       aws = aws.a
#     }
#     peer_region        = var.region2
#     main_vpc_id        = module.vpc1.vpc-id
#     peer_vpc_id        = module.vpc2.vpc-id
#     vpc_name1          = module.vpc1.vpc-name
#     vpc_name2          = module.vpc2.vpc-name
#     owner              = var.owner

#     depends_on = [
#       module.vpc1, module.vpc2
#     ]
# }

# #### output the vpc peering ID to use in acceptor module
# output "vpc_peering_connection_id" {
#   description = "VPC peering connection ID"
#   value = module.vpc-peering-requestor.vpc_peering_connection_id
# }

# #### VPC peering acceptor, accept from region B (VPC B) to region A (VPC A)
# module "vpc-peering-acceptor" {
#     source             = "./modules/vpc-peering-acceptor"
#     providers = {
#       aws = aws.b
#     }
#     vpc_peering_connection_id = module.vpc-peering-requestor.vpc_peering_connection_id

#     depends_on = [
#       module.vpc1, module.vpc2, module.vpc-peering-requestor
#     ]
# }

# #### Route table association in reigon A (VPC A) for vpc peering id to VPC CIDR in Region B
# module "vpc-peering-routetable1" {
#     source             = "./modules/vpc-peering-routetable"
#     providers = {
#       aws = aws.a
#     }
#     peer_vpc_id               = module.vpc2.vpc-id
#     main_vpc_route_table_id   = module.vpc1.route-table-id
#     vpc_peering_connection_id = module.vpc-peering-requestor.vpc_peering_connection_id
#     peer_vpc_cidr      = var.vpc_cidr2

#     depends_on = [
#       module.vpc1, 
#       module.vpc2, 
#       module.vpc-peering-requestor,
#       module.vpc-peering-acceptor
#     ]
# }

########### Node Module
#### Create RE and Test nodes
#### Ansible playbooks configure and install RE software on nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes1" {
    source             = "./modules/nodes"
    providers = {
      aws = aws.a
    }
    owner              = var.owner
    region             = var.region1
    vpc_cidr           = var.vpc_cidr1
    subnet_azs         = var.subnet_azs1
    ssh_key_name       = var.ssh_key_name1
    ssh_key_path       = var.ssh_key_path1
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    #re_download_url    = var.re_download_url
    #data-node-count    = var.data-node-count
    #re_instance_type   = var.re_instance_type
    ebs-volume-size    = var.ebs-volume-size
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc1.vpc-name
    vpc_subnets_ids    = module.vpc1.subnet-ids
    vpc_id             = module.vpc1.vpc-id
}

# #### Node Outputs to use in future modules
# output "re-data-node-eips1" {
#   value = module.nodes1.re-data-node-eips
# }

# output "re-data-node-internal-ips1" {
#   value = module.nodes1.re-data-node-internal-ips
# }

# output "re-data-node-eip-public-dns1" {
#   value = module.nodes1.re-data-node-eip-public-dns
# }

# ########### DNS Module
# #### Create DNS (NS record, A records for each RE node and its eip)
# #### Currently using existing dns hosted zone
# module "dns1" {
#     source             = "./modules/dns"
#     providers = {
#       aws = aws.a
#     }
#     dns_hosted_zone_id = var.dns_hosted_zone_id
#     data-node-count    = var.data-node-count
#     ### vars pulled from previous modules
#     vpc_name           = module.vpc1.vpc-name
#     re-data-node-eips  = module.nodes1.re-data-node-eips
# }

# #### dns FQDN output used in future modules
# output "dns-ns-record-name1" {
#   value = module.dns1.dns-ns-record-name
# }