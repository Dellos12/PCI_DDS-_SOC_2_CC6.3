package main

# Por padrão, o plano é bloqueado
default allow = false

# Permite o deploy apenas se não houver NENHUMA violação
allow {
    count(violations) == 0
}

# REGRA DE AUDITORIA: Bloqueio de SSH Aberto para o Mundo (SOC 2 CC6.1 / PCI-DSS 1.2)
violations[msg] {
    # Procura por mudanças em recursos do tipo Security Group no plano
    resource := input.resource_changes[_]
    resource.type == "aws_security_group"
    
    # Analisa as regras de entrada (ingress) que serão criadas
    ingress := resource.change.after.ingress[_]
    
    # Verifica se a regra cobre a porta 22 (SSH)
    ingress.from_port <= 22
    ingress.to_port >= 22
    
    # Verifica se o tráfego é permitido de qualquer IP público (0.0.0.0/0)
    ingress.cidr_blocks[_] == "0.0.0.0/0"
    
    # Mensagem detalhada para o relatório de auditoria do pipeline
    msg := sprintf("🚨 [SOC 2 / PCI-DSS] Alerta de Risco Econômico: O Security Group '%v' está expondo a porta SSH (22) publicamente para a internet!", [resource.name])
}
