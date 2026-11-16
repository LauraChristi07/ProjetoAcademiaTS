import type { NovaTarefa, Status, Tarefa } from "./tipos";

// A ajudante que todas as chamadas usam: monta o pedido e trata o erro
async function enviar(metodo: string, url: string, corpo?: unknown): Promise<Response> {
  const resposta = await fetch(url, {
    method: metodo,
    headers: { "Content-Type": "application/json" },
    body: corpo === undefined ? undefined : JSON.stringify(corpo),
  });
  if (!resposta.ok) {
    // a API manda { erro: "..." }; se não mandar, usamos o código
    const dados = (await resposta.json().catch(() => ({}))) as { erro?: string };
    throw new Error(dados.erro ?? `Erro ${resposta.status}`);
  }
  return resposta;
}

// JSON não tem data: criadaEm chega como texto e precisa virar Date
function converter(tarefa: Tarefa): Tarefa {
  return { ...tarefa, criadaEm: new Date(tarefa.criadaEm) };
}

export async function listarTarefas(): Promise<Tarefa[]> {
  const resposta = await enviar("GET", "/api/tarefas");
  const bruto = (await resposta.json()) as Tarefa[];
  return bruto.map(converter);
}

export async function cadastrarTarefa(dados: NovaTarefa): Promise<Tarefa> {
  const resposta = await enviar("POST", "/api/tarefas", dados);
  return converter((await resposta.json()) as Tarefa);
}

export async function alterarStatus(id: number, status: Status): Promise<void> {
  await enviar("PATCH", `/api/tarefas/${id}/status`, { status });
}

export async function removerTarefa(id: number): Promise<void> {
  await enviar("DELETE", `/api/tarefas/${id}`);
}
