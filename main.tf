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

# A ENGRENAGEM CRÍTICA: O Security Group (A nossa muralha)
resource "aws_security_group" "sg_auditado" {
  name        = "sg-vulneravel-auditoria"
  description = "Security Group de teste para validacao do OPA"
  vpc_id      = aws_vpc.vpc_economia.id

  # ❌ VIOLAÇÃO CRÍTICA DE SEGURANÇA (SOC 2 CC6.1 / PCI-DSS 1.2)
  # Este bloco abre a porta SSH (22) para QUALQUER IP do planeta terra (0.0.0.0/0)
  ingress {
    description      = "Acesso SSH público"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
