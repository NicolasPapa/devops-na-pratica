# SEGURANÇA: firewall do servidor (security group).
# Regra de ouro: liberar só o necessário.

resource "aws_security_group" "app" {
  name        = "${var.project_name}-sg"
  description = "Libera a porta da API e SSH restrito"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${var.project_name}-sg" }
}

# Entrada: qualquer pessoa pode acessar a API
resource "aws_vpc_security_group_ingress_rule" "app_http" {
  security_group_id = aws_security_group.app.id
  description       = "Acesso publico a API de Tarefas"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.app_port
  to_port           = var.app_port
  ip_protocol       = "tcp"
}

# Entrada: SSH só a partir do IP autorizado (administração)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.app.id
  description       = "SSH apenas do IP do administrador"
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Saída: servidor pode acessar a internet (baixar Node.js, código e dependências)
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.app.id
  description       = "Saida liberada para atualizacoes e dependencias"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
