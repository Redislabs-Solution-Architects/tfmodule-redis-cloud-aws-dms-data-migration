terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
      configuration_aliases = [ aws.a]
    }
  }
}

#### AWS region and AWS key pair for region A
#### Cluster A will live in region A and use this provider
provider "aws" {
  alias      = "a"
  region     = var.region1
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}