// =========================================================
// main.ts — AULA 6: filtros, busca, painel do banco, aviso e tags
// =========================================================
import { campo, elemento, selecao } from "./dom";
import {
  alterarStatus,
  buscarEstatisticas,
  cadastrarTarefa,
  criarConta,
  encerrarSessao,
  entrar,
  guardarSessao,
  listarTarefas,
  removerTarefa,
  sessaoAtual,
} from "./api";
import {
  existeDificilPlanejado,
  filtrarPorStatus,
  ordenarPorNivel,
  pesquisarPorTitulo,
  todasFeitas,
} from "./servicos";
import type { Nivel, Status, Tarefa } from "./tipos";

elemento("nome-do-sistema").textContent = "Academia";
elemento("versao").textContent = "v0.6.0";
elemento("data-de-hoje").textContent = new Date().toLocaleDateString("pt-BR");

// ---------- O estado do programa ----------
let lista: Tarefa[] = [];
let statusSelecionado: Status | "todos" = "todos"; // NOVO: o filtro escolhido
let termoDeBusca = ""; // NOVO: o que foi digitado na busca

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
    item.classList.add("tarefa--feito");
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

  // Exercícios em uma seção expansível
  const detalhes = document.createElement("details");
  detalhes.className = "tarefa__detalhes";

  const resumo = document.createElement("summary");
  resumo.textContent = `Ver exercícios (${tarefa.exercicios.length})`;

  const listaExercicios = document.createElement("ul");
  listaExercicios.className = "tarefa__exercicios";

  tarefa.exercicios.forEach((exercicio) => {
    const itemExercicio = document.createElement("li");
    itemExercicio.textContent = exercicio;
    listaExercicios.append(itemExercicio);
  });

  detalhes.append(resumo, listaExercicios);

  meta.append(etiqueta, situacao);
  principal.append(titulo, meta, detalhes);

  // Botões de ação da tarefa
  const acoes = document.createElement("div");
  acoes.className = "tarefa__acoes";

  if (tarefa.status !== "feito") {
    acoes.append(
      botao("pulado", "", () => mudarStatus(tarefa.id, "pulado")),
      botao("Concluir", "botao--sucesso", () => mudarStatus(tarefa.id, "feito"))
    );
  } else {
    acoes.append(
      botao("Reabrir", "", () => mudarStatus(tarefa.id, "planejado"))
    );
  }

  acoes.append(
    botao("Remover", "botao--perigo", () => remover(tarefa.id))
  );

  item.append(principal, acoes);

  return item;
}

// Quais tarefas mostrar: filtrar, pesquisar, ordenar.
// O filtro muda o que é MOSTRADO, nunca a lista que existe.
function tarefasVisiveis(): Tarefa[] {
  let resultado = lista;

  if (statusSelecionado !== "todos") {
    resultado = filtrarPorStatus(resultado, statusSelecionado);
  }

  if (termoDeBusca.trim() !== "") {
    resultado = pesquisarPorTitulo(resultado, termoDeBusca);
  }

  return ordenarPorNivel(resultado);
}

// O painel vem pronto do banco (GROUP BY)
async function atualizarPainel(): Promise<void> {
  const contagem = await buscarEstatisticas();
  const total = contagem.planejado + contagem.pulado + contagem.feito;

  elemento("total").textContent = String(total);
  elemento("Planejado").textContent = String(contagem.planejado);
  elemento("Pulado").textContent = String(contagem.pulado);
  elemento("Feito").textContent = String(contagem.feito);
}

// ---------- Barra de progresso dos treinos ----------
function atualizarProgresso(): void {
  const total = lista.length;
  const concluidos = lista.filter((t) => t.status === "feito").length;

  const porcentagem = total > 0
    ? Math.round((concluidos / total) * 100)
    : 0;

  elemento("porcentagem-progresso").textContent = `${porcentagem}%`;

  const barra = elemento("barra-progresso");
  barra.style.width = `${porcentagem}%`;
  barra.setAttribute("aria-valuenow", String(porcentagem));

  elemento("texto-progresso").textContent =
    `${concluidos} de ${total} treinos concluídos.`;
}

function desenhar(): void {
  const visiveis = tarefasVisiveis();

  atualizarProgresso();

  elemento("lista").replaceChildren(...visiveis.map(criarItem));
  elemento("vazio").hidden = visiveis.length > 0;

  // some: existe pelo menos uma urgente planejadas?
  elemento("aviso-urgente").classList.toggle("aviso--oculto", !existeDificilPlanejado(lista));

  // every: todas concluídas?
  if (todasFeitas(lista)) {
    console.log("Parabéns: nenhuma tarefa em aberto!");
  }

  atualizarPainel().catch(mostrarErro);
}

// O par que você repete em toda ação:
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

// ---------- Filtros e busca (Aula 6) ----------
// Os botões de filtro: um só "ouvinte" para o grupo inteiro
elemento("filtros-status").addEventListener("click", (evento) => {
  const alvo = evento.target;

  if (!(alvo instanceof HTMLButtonElement)) return;

  const escolhido = alvo.dataset.status;
  if (!escolhido) return;

  statusSelecionado = escolhido as Status | "todos";

  for (const b of elemento("filtros-status").querySelectorAll("button")) {
    b.classList.toggle("filtro--ativo", b === alvo);
  }

  desenhar();
});

// A busca filtra enquanto o usuário digita
campo("busca").addEventListener("input", () => {
  termoDeBusca = campo("busca").value;
  desenhar();
});

// ---------- A tela de entrada (Aula 5) ----------
function mostrarErroEntrada(erro: unknown): void {
  const mensagem = erro instanceof Error ? erro.message : "Erro inesperado.";
  elemento("erro-entrada").textContent = mensagem;
}

// Troca entre "Entrar" e "Criar conta"
function mostrarFormulario(criando: boolean): void {
  elemento("form-criar").hidden = !criando;
  elemento("form-entrar").hidden = criando;

  elemento("alternar-entrada").textContent = criando
    ? "Já tenho conta"
    : "Ainda não tenho conta";

  elemento("erro-entrada").textContent = "";
}

elemento("alternar-entrada").addEventListener("click", () => {
  mostrarFormulario(elemento("form-criar").hidden === true); // escondido? então mostra
});

elemento("form-entrar").addEventListener("submit", async (evento) => {
  evento.preventDefault();

  try {
    guardarSessao(await entrar(campo("entrar-email").value, campo("entrar-senha").value));
    campo("entrar-senha").value = "";
    await iniciar();
  } catch (erro) {
    mostrarErroEntrada(erro);
  }
});

elemento("form-criar").addEventListener("submit", async (evento) => {
  evento.preventDefault();

  const email = campo("criar-email").value;
  const senha = campo("criar-senha").value;

  try {
    await criarConta(campo("criar-nome").value, email, senha);
    guardarSessao(await entrar(email, senha)); // criou? já entra direto
    (elemento("form-criar") as HTMLFormElement).reset(); // não deixa a senha no campo
    await iniciar();
  } catch (erro) {
    mostrarErroEntrada(erro);
  }
});

elemento("botao-sair").addEventListener("click", () => {
  encerrarSessao();
  lista = [];
  (elemento("form-entrar") as HTMLFormElement).reset();
  mostrarFormulario(false); // volta sempre para "Entrar"
  iniciar();
});

// ---------- O começo: com sessão, mostra o sistema; sem, a entrada ----------
async function iniciar(): Promise<void> {
  const sessao = sessaoAtual();

  elemento("tela-entrada").hidden = sessao !== undefined;
  elemento("tela-app").hidden = sessao === undefined;
  elemento("botao-sair").hidden = sessao === undefined;
  elemento("usuario-nome").textContent = sessao?.nome ?? "";

  if (!sessao) {
    return;
  }

  elemento("erro-entrada").textContent = "";

  try {
    lista = await listarTarefas();
    desenhar();
  } catch (erro) {
    mostrarErro(erro);
  }
}

iniciar();