
### Redis Cloud Subscription peering

resource "rediscloud_subscription_peering" "example" {
   subscription_id = var.rediscloud_subscription_id
   region = var.aws_customer_application_vpc_region
   aws_account_id = var.aws_customer_application_aws_account_id
   vpc_id = var.aws_customer_application_vpc_id
   vpc_cidr = var.aws_customer_application_vpc_cidr
}


resource "aws_vpc_peering_connection_accepter" "example-peering" {
  vpc_peering_connection_id = rediscloud_subscription_peering.example.aws_peering_id
  auto_accept               = true
}

### AWS Terrafrom to add route table in customer AWS environment
### ADD ROUTE TABLE ROUTE


# Declare the data source
data "aws_vpc_peering_connection" "pc" {
  peer_vpc_id     = var.aws_customer_application_vpc_id
  peer_cidr_block = var.aws_customer_application_vpc_cidr #AWS Customer VPC CIDR block
  cidr_block      = var.rc_networking_deployment_cidr #Redis Cloud Subscription VPC CIDR block
  status          = "active"
  depends_on      = [aws_vpc_peering_connection_accepter.example-peering]
}

## output of the sub id
output "aws_vpc_peering_connection" {
  value = data.aws_vpc_peering_connection.pc.id
}

# Create a route
resource "aws_route" "r" {
  route_table_id            = var.aws_vpc_route_table_id
  destination_cidr_block    = var.rc_networking_deployment_cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.pc.id
}