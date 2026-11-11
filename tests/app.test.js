// Testes automatizados da API de Tarefas.
// O supertest faz requisições HTTP "de mentira" direto no app, sem abrir porta.
// Cada teste cria um app novo (beforeEach) para um teste não interferir no outro.

const request = require('supertest');
const { criarApp } = require('../src/app');

let app;

beforeEach(() => {
  app = criarApp();
});

describe('GET /health', () => {
  test('responde 200 com status ok', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('POST /tarefas', () => {
  test('cria uma tarefa com título válido', async () => {
    const res = await request(app).post('/tarefas').send({ titulo: 'Estudar CI' });
    expect(res.status).toBe(201);
    expect(res.body).toEqual({ id: 1, titulo: 'Estudar CI', concluida: false });
  });

  test('recusa tarefa sem título (regra de negócio)', async () => {
    const res = await request(app).post('/tarefas').send({});
    expect(res.status).toBe(400);
  });

  test('recusa título só com espaços', async () => {
    const res = await request(app).post('/tarefas').send({ titulo: '   ' });
    expect(res.status).toBe(400);
  });
});

describe('GET /tarefas', () => {
  test('lista as tarefas criadas', async () => {
    await request(app).post('/tarefas').send({ titulo: 'Tarefa A' });
    await request(app).post('/tarefas').send({ titulo: 'Tarefa B' });

    const res = await request(app).get('/tarefas');
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
  });
});

describe('PATCH /tarefas/:id/concluir', () => {
  test('marca a tarefa como concluída', async () => {
    await request(app).post('/tarefas').send({ titulo: 'Fazer push' });

    const res = await request(app).patch('/tarefas/1/concluir');
    expect(res.status).toBe(200);
    expect(res.body.concluida).toBe(true);
  });

  test('retorna 404 para tarefa inexistente', async () => {
    const res = await request(app).patch('/tarefas/999/concluir');
    expect(res.status).toBe(404);
  });
});
