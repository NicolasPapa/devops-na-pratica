# Provider = o "tradutor" entre o Terraform e a nuvem (aqui, a AWS).
provider "aws" {
  region = var.aws_region

  # Tags aplicadas automaticamente em TODOS os recursos criados.
  # Facilitam saber de qual projeto/ambiente é cada recurso (e o custo de cada um).
  default_tags {
    tags = {
      Projeto    = var.project_name
      Ambiente   = var.environment
      Gerenciado = "terraform"
    }
  }
}
