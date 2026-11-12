# Versões exigidas: garante que todos (você, o professor e o pipeline)
# usem o mesmo Terraform e o mesmo provider, evitando "na minha máquina funciona".
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
