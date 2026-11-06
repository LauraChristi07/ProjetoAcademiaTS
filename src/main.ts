import { elemento } from "./dom";
import { tarefas } from "./dados";

const nomeDoSistema: string = "Academia";
const versao: string = "0.1.1";
const hoje: string = new Date().toLocaleDateString("pt-BR");
const autor = "Academia"; // inferência: o TypeScript deduz que é string

elemento("nome-do-sistema").textContent = nomeDoSistema;
elemento("versao").textContent = `v${versao}`;
elemento("data-de-hoje").textContent = hoje;
console.log(`TaskFlow iniciado. Autor: ${autor}`); // aparece no F12

const lista = elemento("lista");

// LAÇO 1 — for...of: percorre os treinos sem precisar utilizar índices.
for (const tarefa of tarefas) {
  const item = document.createElement("li"); // Cria um item de lista para cada treino.
  item.className = `tarefa tarefa--${tarefa.nivel}`; // Aplica classes CSS de acordo com o nível do treino.

  if (tarefa.status === "feito") { // Verifica se o treino já foi concluído.
    item.classList.add("tarefa--concluida"); // Adiciona uma classe para destacar visualmente os treinos concluídos.
  }

  const titulo = document.createElement("h3"); // Cria um título para o treino.
  titulo.className = "tarefa__titulo"; // Aplica a classe CSS do título.
  titulo.textContent = `#${tarefa.id} ${tarefa.titulo}`; // Exibe o número e o nome do treino.

  const etiqueta = document.createElement("span"); // Cria uma etiqueta para mostrar o nível.
  etiqueta.className = `etiqueta etiqueta--${tarefa.nivel}`; // Aplica uma classe CSS conforme o nível.
  etiqueta.textContent = tarefa.nivel; // Exibe o nível do treino.

  const status = document.createElement("p"); // Cria um parágrafo para mostrar o status.
  status.textContent = `Status: ${tarefa.status}`; // Exibe se o treino está planejado, feito ou pulado.

  const exercicios = document.createElement("p"); // Cria um parágrafo para mostrar os exercícios.
  exercicios.textContent = `Exercícios: ${tarefa.exercicios.join(", ")}`; // Junta os exercícios em um texto separado por vírgulas.

  item.append(titulo, status, exercicios, etiqueta); // Coloca o título, a etiqueta, o status e os exercícios dentro do item.
  lista.append(item); // Adiciona o item completo à lista exibida na página.
}

// LAÇO 2 — for com índice: contando as pendentes
let pendentes = 0;
for (let i = 0; i < tarefas.length; i++) {
  if (tarefas[i].status === "planejado") {
    pendentes++;
  }
}

elemento("total").textContent = String(tarefas.length);
elemento("pendentes").textContent = String(pendentes);
// LAÇO 3 — while: achar a primeira tarefa de nivel alto
// (não sabemos quantas voltas: o laço para assim que encontra)
let posicao = 0;
while (posicao < tarefas.length && tarefas[posicao].nivel !== "dificil") {
  posicao++;
}
if (posicao < tarefas.length) {
  const urgente = tarefas[posicao];
  elemento("comece-por").textContent =
    `Comece por: #${urgente.id} ${urgente.titulo}`;
  elemento("comece-por").hidden = false;
}
