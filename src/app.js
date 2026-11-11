// API de Tarefas: a "carga" que passa pelo pipeline de CI.
// Este arquivo só MONTA o app (rotas e regras). Quem liga o servidor é o server.js.
// Separar os dois permite testar o app sem abrir uma porta de rede de verdade.

const express = require('express');

function criarApp() {
  const app = express();
  app.use(express.json()); // permite ler o corpo das requisições em JSON

  // "Banco de dados" em memória: some quando o app reinicia (suficiente para o projeto)
  const tarefas = [];
  let proximoId = 1;

  // Health check: rota que diz "estou vivo". Usada por monitoramento e deploy (Fase 2).
  app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
  });

  // Lista todas as tarefas
  app.get('/tarefas', (req, res) => {
    res.status(200).json(tarefas);
  });

  // Cria uma tarefa. Regra de negócio: o título é obrigatório.
  app.post('/tarefas', (req, res) => {
    const { titulo } = req.body || {};

    if (typeof titulo !== 'string' || titulo.trim() === '') {
      return res.status(400).json({ erro: 'O campo "titulo" é obrigatório.' });
    }

    const tarefa = { id: proximoId++, titulo: titulo.trim(), concluida: false };
    tarefas.push(tarefa);
    return res.status(201).json(tarefa);
  });

  // Marca uma tarefa como concluída
  app.patch('/tarefas/:id/concluir', (req, res) => {
    const tarefa = tarefas.find((t) => t.id === Number(req.params.id));

    if (!tarefa) {
      return res.status(404).json({ erro: 'Tarefa não encontrada.' });
    }

    tarefa.concluida = true;
    return res.status(200).json(tarefa);
  });

  return app;
}

module.exports = { criarApp };
