# Outputs: informações mostradas no fim do "terraform apply".

output "instance_public_ip" {
  description = "IP público do servidor"
  value       = aws_instance.app.public_ip
}

output "app_url" {
  description = "Endereço do health check da API"
  value       = "http://${aws_instance.app.public_ip}:${var.app_port}/health"
}

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "security_group_id" {
  description = "ID do security group da aplicação"
  value       = aws_security_group.app.id
}
