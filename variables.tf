#### Provider variables
variable "region" {
    description = "AWS region"
}

variable "aws_creds" {
    description = "Access key and Secret key for AWS [Access Keys, Secret Key]"
}

#### Important variables
variable "ssh_key_name" {
    description = "name of ssh key to be added to instance"
}

variable "owner" {
    description = "owner tag name"
}

#### VPC
################################################ AWS VPC
variable "prefix_name" {
    description = "base name for resources (prefix name)"
    default = "redisuser1-tf"
}

variable "aws_account_id" {
    description = "aws_account_id"
}

variable "vpc_cidr" {
    description = "aws_customer_application_vpc_cidr"
    #default = "10.0.0.0/16"
}

#### Declare the list of availability zones
variable "subnet_azs" {
  type = list(string)
  #default = ["us-east-1a","us-east-1b","us-east-1c"]
}

#### Declare the list of subnet CIDR blocks
variable "subnet_cidr_blocks" {
    type = list(string)
    description = "subnet_cidr_block"
    #default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}


################################################ mysql Instance Variables
variable "mysql-node-count" {
  description = "number of data nodes"
  default     = 1
}

variable "mysql_instance_type" {
    description = "instance type to use. Default: t3.micro"
    default = "t3.micro"
}


################################################ EBS volume
variable "ebs-volume-size" {
  description = "The size of the ebs volumes to attach"
  default     = "40"
}

#### Security
variable "open-nets" {
  type        = list(any)
  description = "CIDRs that will have access to everything"
  default     = []
}

variable "allow-public-ssh" {
  description = "Allow SSH to be open to the public - enabled by default"
  default     = "1"
}

variable "internal-rules" {
  description = "Security rules to allow for connectivity within the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      comment   = "SSH from VPC"
    },
    {
      type      = "ingress"
      from_port = "3306"
      to_port   = "3306"
      protocol  = "tcp"
      comment   = "MySQL from VPC"
    }
  ]
}

variable "external-rules" {
  description = "Security rules to allow for connectivity external to the VPC"
  type        = list(any)
  default = [
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      cidr      = ["0.0.0.0/0"]
    }
  ]
}

##################################### Redis Cloud Variables

##################### Redis Cloud Variables

variable "rediscloud_creds" {
    description = "Access key and Secret key for Redis Cloud account"
}

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

################################ Redis Cloud Subscription Variables

variable "rc_region" {
    description = "redis cloud aws region"
    default = "us-east-1"
}

variable "rc_networking_deployment_cidr" {
    description = "the CIDR of your RedisCloud deployment, MUST BE /24"
    default = "10.1.0.0/24"
}

variable "rc_preferred_availability_zones" {
    description = "redis cloud subscription azs"
    type        = list(any)
    default = ["us-east-1a","us-east-1b","us-east-1c"]
}

variable "rc_memory_storage" {
    description = "Memory storage preference: either 'ram' or a combination of 'ram-and-flash'. Default: 'ram'"
    default = "ram"
}

##### Redis Cloud Creation Plan Variables
##### The Creation plan defines the infra for the RE Subscription Cluster, it does not deploy a db.
variable "rc_cp_average_item_size_in_bytes" {
    description = "Relevant only to ram-and-flash clusters. Estimated average size (measured in bytes) of the items stored in the database. The value needs to be the maximum average item size defined in one of your databases."
    default = 1
}

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



######################################## Redis Cloud Database Variables
variable "rc_db_external_endpoint_for_oss_cluster_api" {
    description = "Should use the external endpoint for open-source (OSS) Cluster API. Can only be enabled if OSS Cluster API support is enabled"
    default = false
}

variable "rc_db_data_persistence" {
    description = "Rate of database data persistence (in persistent storage)"
    default = "none"
}

variable "rc_db_memory_limit_in_gb" {
    description = "Maximum memory usage that will be used for your database."
    default = 1
}

variable "rc_db_name" {
    description = "database name"
    default = "example-db"
}

variable "rc_db_replication" {
    description = "Databases replication. Set to true if any of your databases will use replication."
    default = false
}

variable "rc_db_support_oss_cluster_api" {
    description = "Support Redis open-source (OSS) Cluster API"
    default = false
}

variable "rc_db_throughput_measurement_by" {
    description = "Throughput measurement method that will be used by your database, (either 'number-of-shards' or 'operations-per-second')"
    default = "operations-per-second"
}

variable "rc_db_throughput_measurement_value" {
    description = "Throughput value that will be used by your databases (as applies to selected measurement method)."
    default = 1000
}

variable "rc_db_modules" {
    description = "a list of modules that will be used by the database. Not currently compatible with 'ram-and-flash' memory storage"
    type        = list(map(string))
    default = [
        {
          "name": "RedisJSON"
        },
        {
          "name": "RedisBloom"
        }
    ]
}