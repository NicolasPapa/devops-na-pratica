// Ponto de entrada: liga o servidor HTTP numa porta.
// A porta vem da variável de ambiente PORT (padrão em servidores e containers) ou usa 3000.

const { criarApp } = require('./app');

const PORT = process.env.PORT || 3000;

criarApp().listen(PORT, () => {
  console.log(`API de Tarefas rodando na porta ${PORT}`);
});
