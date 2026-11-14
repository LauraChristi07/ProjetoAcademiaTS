import { campo, elemento, selecao } from "./dom";
import { buscarTarefa, listarTarefas } from "./api";
import type { Nivel, Tarefa } from "./tipos";
import { adicionarTarefa } from "./servicos";
elemento("nome-do-sistema").textContent = "Academia";
elemento("versao").textContent = "v0.3.0";
elemento("data-de-hoje").textContent = new Date().toLocaleDateString("pt-BR");
// Começa vazia: quem preenche é a API (e por isso é let, não const)
let lista: Tarefa[] = [];
function criarItem(tarefa: Tarefa): HTMLLIElement {
const item = document.createElement("li");
item.className = `tarefa tarefa--${tarefa.nivel}`;
const titulo = document.createElement("h3");
titulo.className = "tarefa__titulo";
titulo.textContent = `#${tarefa.id} ${tarefa.titulo}`;
const meta = document.createElement("div");
meta.className = "tarefa__meta";
const etiqueta = document.createElement("span");
etiqueta.className = `etiqueta etiqueta--${tarefa.nivel}`;
etiqueta.textContent = tarefa.nivel;
const situacao = document.createElement("span");
situacao.className = "etiqueta etiqueta--status";
situacao.textContent = tarefa.status;
// map de novo: cada exercicio vira um <span>
const  exercicios = tarefa.exercicios.map((exercicio) => {
const elementoExercicio = document.createElement("span");
elementoExercicio.className = "exercicio";
elementoExercicio.textContent = exercicio;
return elementoExercicio;
});
meta.append(etiqueta, situacao, ...exercicios);
item.append(titulo, meta);
return item;
}
function desenhar(): void {
// map: o seu transformar da Aula 2, que já vem pronto
elemento("lista").replaceChildren(...lista.map(criarItem));
// filter: só as que passam no teste
const pendentes = lista.filter((t) => t.status === "planejado");
elemento("total").textContent = String(lista.length);
elemento("pendentes").textContent = String(pendentes.length);
}
// O cadastro ainda grava só na tela. Na Aula 4 ele vai para o banco.
12
elemento("formulario").addEventListener("submit", (evento) => {
evento.preventDefault();
elemento("erro").textContent = "";
try {
adicionarTarefa(lista, {
titulo: campo("titulo").value.trim(),
nivel: selecao("nivel").value as Nivel,
exercicios: [],
});
campo("titulo").value = "";
desenhar();
} catch (erro) {
if (erro instanceof Error) {
elemento("erro").textContent = erro.message;
}
}
});
// O começo do programa: busca no banco, depois desenha
async function iniciar(): Promise<void> {
try {
lista = await listarTarefas();
desenhar();
} catch (erro) {
if (erro instanceof Error) {
elemento("erro").textContent = erro.message;
}
}
// find no banco: pode não encontrar
const procurada = await buscarTarefa(3);
if (procurada) {
console.log(`Encontrada: ${procurada.titulo}`);
} else {
console.log("Tarefa #3 não existe.");
}
}
iniciar();
