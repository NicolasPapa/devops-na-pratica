// Script de build: gera a pasta dist/ com só o que o app precisa para rodar em produção.
// Esse "pacote" é o artefato que a Fase 2 (CD e Docker) vai usar.

const fs = require('fs');
const path = require('path');

const raiz = path.join(__dirname, '..');
const dist = path.join(raiz, 'dist');

fs.rmSync(dist, { recursive: true, force: true }); // limpa build anterior
fs.mkdirSync(dist);

fs.cpSync(path.join(raiz, 'src'), path.join(dist, 'src'), { recursive: true });
fs.copyFileSync(path.join(raiz, 'package.json'), path.join(dist, 'package.json'));
fs.copyFileSync(path.join(raiz, 'package-lock.json'), path.join(dist, 'package-lock.json'));

console.log('Build concluído: dist/ pronto.');
