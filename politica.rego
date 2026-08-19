package main

# Por padrão, o plano é bloqueado
default allow = false

# ✅ SINTAXE CORRIGIDA: Adicionado o "if" obrigatório antes do corpo da regra
allow if {
    count(violations) == 0
}

# ✅ SINTAXE CORRIGIDA: Uso do "contains" e "if" para regras de conjunto parcial (Set Rules)
violations contains msg if {
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
