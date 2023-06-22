

resource "aws_dms_endpoint" "redis_endpoint" {
  endpoint_id           = "dms-redis-endpoint"
  endpoint_type         = "target"
  engine_name           = "redis"
  redis_settings {
    server_name              = var.redis_db_endpoint
    port                     = 12000
    ssl_security_protocol    = "plaintext"
    auth_type                = "auth-token"
    auth_password            = var.redis_db_password
  }
  #extra_connection_attributes = "{\"ServerName\":\"${var.redis_db_endpoint}\",\"Port\":\"12000\",\"SslSecurityProtocol\":\"plaintext\",\"AuthType\":\"auth-token\"}"


  tags = {
    Name  = "dms-target-endpoint"
    Owner = "bamos"
  }

}