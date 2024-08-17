
output "load_balancer_dns" {
  value = aws_lb.pythonapp_lb.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.pythonapp_db.endpoint
}

output "db_port" {
  value = aws_db_instance.pythonapp_db.port
}
