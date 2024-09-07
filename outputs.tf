output "staging_instance_public_ip" {
  value = aws_instance.staging.public_ip
}

output "production_instance_public_ip" {
  value = aws_instance.production.public_ip
}

output "load_balancer_dns" {
  value = aws_lb.app_lb.dns_name
}
