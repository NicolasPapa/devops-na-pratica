# Diário de decisões técnicas

Registro do que foi decidido e por quê. Base para o relatório final (Fase 2).

| Data | Decisão | Motivo |
| --- | --- | --- |
| 09/11/2026 | API REST em Node.js + Express | Simples, mesma stack usada na Aula 10, fácil de containerizar na Fase 2 |
| 09/11/2026 | Dados em memória (sem banco) | O foco do projeto é o fluxo DevOps, não a persistência |
| 09/11/2026 | Separar `app.js` de `server.js` | Permite testar a API sem abrir porta de rede |
| 09/11/2026 | Jest + Supertest | Testes de integração das rotas HTTP, com relatório de cobertura |
| 10/11/2026 | GitHub Actions para CI | Integrado ao repositório, gratuito para repositórios públicos |
| 10/11/2026 | `npm ci` no pipeline | Instala exatamente as versões do `package-lock.json` (build reproduzível) |
| 11/11/2026 | Terraform com provider AWS | Ferramenta de IaC citada no enunciado; AWS usada nas aulas |
| 11/11/2026 | Terraform validado, não aplicado | Evita custo; `fmt` + `validate` no CI garantem que o código é correto |
| 11/11/2026 | SSH restrito a um IP, IMDSv2 e disco criptografado | Boas práticas de segurança desde o início (DevSecOps) |
| 11/11/2026 | Actions atualizadas para v5 | Remove o aviso de Node.js 20 descontinuado no GitHub Actions |

## Melhorias futuras

- Exigir cobertura mínima de testes no pipeline
- Tratar as vulnerabilidades apontadas pelo `npm audit` (ferramentas de desenvolvimento)
- Guardar o state do Terraform em um backend remoto (S3) quando houver apply real
