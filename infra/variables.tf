# Variáveis: tudo que pode mudar entre ambientes fica aqui, nada "chumbado" no código.
# Valores reais vão no terraform.tfvars (que NÃO vai para o GitHub).

variable "aws_region" {
  description = "Região da AWS onde a infraestrutura será criada"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto, usado para nomear os recursos"
  type        = string
  default     = "devops-na-pratica"
}

variable "environment" {
  description = "Ambiente (dev, staging ou prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, staging ou prod."
  }
}

variable "vpc_cidr" {
  description = "Faixa de IPs da rede privada (VPC)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Faixa de IPs da sub-rede pública onde fica o servidor"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Tamanho do servidor (t3.micro entra no nível gratuito da AWS)"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Porta em que a API de Tarefas escuta"
  type        = number
  default     = 3000
}

variable "allowed_ssh_cidr" {
  description = "IP autorizado a acessar o servidor via SSH (use o seu IP com /32, nunca 0.0.0.0/0)"
  type        = string
  default     = "127.0.0.1/32"
}

variable "key_name" {
  description = "Nome de um par de chaves SSH já existente na AWS (opcional)"
  type        = string
  default     = null
}

variable "repo_url" {
  description = "Repositório Git de onde o servidor baixa o código da aplicação"
  type        = string
  default     = "https://github.com/NicolasPapa/devops-na-pratica.git"
}
