terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  # ✅ CORREÇÃO: Ignora a validação de credenciais reais para permitir o plano estático no GitHub Actions
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

# Criação do VPC (Rede isolada para o processo econômico)
resource "aws_vpc" "vpc_economia" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-processo-economico"
  }
}

# A ENGRENAGEM CORRIGIDA, BLINDADA E COM NOME VÁLIDO
resource "aws_security_group" "sg_auditado" {
  # ✅ CORREÇÃO: Removido o "sg-" inicial para cumprir a regra da AWS/Terraform
  name_prefix = "vulneravel-auditoria-"
  description = "Security Group de teste para validacao do OPA"
  vpc_id      = aws_vpc.vpc_economia.id

  # ✅ CONFORMIDADE ATENDIDA (SOC 2 / PCI-DSS)
  ingress {
    description = "Acesso SSH restrito a rede interna"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_economia.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc_economia]
}
