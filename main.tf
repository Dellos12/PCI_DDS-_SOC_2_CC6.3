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
}

# Criação do VPC (Rede isolada para o processo econômico)
resource "aws_vpc" "vpc_economia" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-processo-economico"
  }
}

# A ENGRENAGEM CORRIGIDA E BLINDADA
resource "aws_security_group" "sg_auditado" {
  # ✅ AJUSTE 1: Evita colisão de nomes adicionando um sufixo aleatório automático
  name_prefix = "sg-vulneravel-auditoria-"
  description = "Security Group de teste para validacao do OPA"
  vpc_id      = aws_vpc.vpc_economia.id

  # ✅ CONFORMIDADE ATENDIDA (SOC 2 / PCI-DSS)
  # O acesso SSH (22) agora está restrito APENAS para IPs internos da nossa VPC (10.0.0.0/16)
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

  # ✅ AJUSTE 2: Garante que a VPC nasça 100% antes de tentar ler o CIDR block dela
  depends_on = [aws_vpc.vpc_economia]
}
