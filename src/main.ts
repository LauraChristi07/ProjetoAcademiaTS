import { campo, elemento, selecao } from "./dom";
import { alterarStatus, cadastrarTarefa, listarTarefas, removerTarefa } from "./api";
import type { Nivel, Status, Tarefa } from "./tipos";

elemento("nome-do-sistema").textContent = "Academia";
elemento("versao").textContent = "v0.4.0";
elemento("data-de-hoje").textContent = new Date().toLocaleDateString("pt-BR");

let lista: Tarefa[] = [];

function mostrarErro(erro: unknown): void {
  elemento("erro").textContent = erro instanceof Error ? erro.message : "Erro inesperado.";
}

// Uma ajudante para criar botões sem repetir código
function botao(texto: string, extra: string, aoClicar: () => void): HTMLButtonElement {
  const elementoBotao = document.createElement("button");
  elementoBotao.type = "button";
  elementoBotao.className = `botao botao--pequeno ${extra}`;
  elementoBotao.textContent = texto;
  elementoBotao.addEventListener("click", aoClicar); // callback, de novo
  return elementoBotao;
}

function criarItem(tarefa: Tarefa): HTMLLIElement {
  const item = document.createElement("li");
  item.className = `tarefa tarefa--${tarefa.nivel}`;
  if (tarefa.status === "feito") {
    item.classList.add("tarefa--concluida");
  }

  const principal = document.createElement("div");

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

  meta.append(etiqueta, situacao);
  principal.append(titulo, meta);

  // Os botões: cada um fecha sobre a SUA tarefa
  const acoes = document.createElement("div");
  acoes.className = "tarefa__acoes";
  if (tarefa.status !== "feito") {
    acoes.append(
      botao("pulado", "", () => mudarStatus(tarefa.id, "pulado")),
      botao("Concluir", "botao--sucesso", () => mudarStatus(tarefa.id, "feito"))
    );
  } else {
    acoes.append(botao("Reabrir", "", () => mudarStatus(tarefa.id, "planejado")));
  }
  acoes.append(botao("Remover", "botao--perigo", () => remover(tarefa.id)));

  item.append(principal, acoes);
  return item;
}

function desenhar(): void {
  elemento("lista").replaceChildren(...lista.map(criarItem));
  const planjeados = lista.filter((t) => t.status === "planejado");
  elemento("total").textContent = String(lista.length);
  elemento("pendentes").textContent = String(planjeados.length);
}

// O par que você vai repetir a noite toda:
// 1. o banco confirma  2. o estado muda sem ser alterado  3. a tela acompanha
async function mudarStatus(id: number, status: Status): Promise<void> {
  try {
    await alterarStatus(id, status);
    lista = lista.map((t) => (t.id === id ? { ...t, status } : t));
    desenhar();
  } catch (erro) {
    mostrarErro(erro);
  }
}

async function remover(id: number): Promise<void> {
  try {
    await removerTarefa(id);
    lista = lista.filter((t) => t.id !== id);
    desenhar();
  } catch (erro) {
    mostrarErro(erro);
  }
}

elemento("formulario").addEventListener("submit", async (evento) => {
  evento.preventDefault();
  elemento("erro").textContent = "";
  try {
    const nova = await cadastrarTarefa({
      titulo: campo("titulo").value.trim(),
      nivel: selecao("nivel").value as Nivel,
      exercicios: [],
    });
    lista = [...lista, nova]; // acrescentar sem alterar: uma lista nova
    campo("titulo").value = "";
    desenhar();
  } catch (erro) {
    mostrarErro(erro);
  }
});

async function iniciar(): Promise<void> {
  try {
    lista = await listarTarefas();
    desenhar();
  } catch (erro) {
    mostrarErro(erro);
  }
}

iniciar();
