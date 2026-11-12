# API de Tarefas — Projeto DevOps na Prática (PUCRS)

![CI](https://github.com/NicolasPapa/devops-na-pratica/actions/workflows/ci.yml/badge.svg)

Projeto individual da disciplina **DevOps na Prática**. Uma API REST simples (Node.js + Express) serve de "carga" para um fluxo DevOps completo: testes automatizados, pipeline de **CI** no GitHub Actions e infraestrutura como código (**IaC**) com Terraform.

## Estrutura

```
.github/workflows/ci.yml   Pipeline de CI (app + Terraform)
src/app.js                 Rotas e regras da API
src/server.js              Liga o servidor na porta (PORT ou 3000)
tests/app.test.js          7 testes automatizados (Jest + Supertest)
scripts/build.js           Gera a pasta dist/ (pacote do app)
infra/                     Scripts Terraform (AWS)
docs/decisoes.md           Diário de decisões técnicas
```

## Rotas da API

| Método | Rota | O que faz | Resposta |
| --- | --- | --- | --- |
| GET | `/health` | Verifica se a API está no ar | 200 `{ "status": "ok" }` |
| GET | `/tarefas` | Lista as tarefas | 200 |
| POST | `/tarefas` | Cria uma tarefa (`titulo` obrigatório) | 201, ou 400 sem título |
| PATCH | `/tarefas/:id/concluir` | Marca a tarefa como concluída | 200, ou 404 se não existir |

## Rodar localmente

```bash
npm install
npm test        # 7 testes + relatório de cobertura
npm run lint    # padrão de código
npm run build   # gera dist/
npm start       # http://localhost:3000/health
```

## Pipeline de CI

Dispara a cada `push` na `main` e a cada pull request. Dois jobs em paralelo:

1. **build-and-test**: `npm ci` → lint → testes → build
2. **terraform**: `terraform fmt -check` → `terraform init -backend=false` → `terraform validate`

Se qualquer etapa falhar, o pipeline fica vermelho e o código não é considerado pronto.

## Infraestrutura (Terraform)

A pasta `infra/` descreve, em código, o ambiente AWS para rodar a API:

- **Rede**: VPC, sub-rede pública, internet gateway e tabela de rotas (`network.tf`)
- **Segurança**: security group liberando a porta da API e SSH restrito a um IP (`security.tf`)
- **Servidor**: instância EC2 `t3.micro` (Ubuntu 22.04) que instala o Node.js e sobe a API como serviço (`compute.tf` + `templates/user_data.sh.tftpl`)

Para criar de verdade (requer conta e credenciais AWS; pode gerar custo):

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars   # ajuste seu IP e região
terraform init
terraform plan      # mostra o que será criado, sem criar
terraform apply     # cria a infraestrutura
terraform destroy   # remove tudo
```

Neste projeto os scripts são **validados no pipeline** e não aplicados, para não gerar custo.
