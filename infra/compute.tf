# SERVIDOR: uma máquina virtual (EC2) que roda a API de Tarefas.

# Busca a imagem mais recente do Ubuntu 22.04 (em vez de fixar um ID que muda por região)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical, empresa dona do Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name

  # Script que roda na PRIMEIRA inicialização: instala Node.js, baixa o código e sobe a API
  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    repo_url = var.repo_url
    app_port = var.app_port
  })

  # Exige o padrão IMDSv2 nos metadados da instância (boa prática de segurança da AWS)
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${var.project_name}-${var.environment}-app" }
}
