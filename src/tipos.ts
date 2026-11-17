export type Nivel = "facil" | "medio" | "dificil";
export type Status = "planejado" | "feito" | "pulado";

export interface Tarefa {
  readonly id: number;
  titulo: string;
  descricao?: string | null;
  nivel: Nivel;
  status: Status;
  exercicios: string[];
  prazo?: string | null; // NOVO: "2026-10-22" ou null
  criadaEm: Date;
}
// O que o usuário informa ao cadastrar:
// id, status e criadaEm são responsabilidade do sistema
export type NovaTarefa = Omit<Tarefa, "id" | "status" | "criadaEm">;
// NOVO: quem está logado. A API devolve isto no login.
export interface Sessao {
token: string;
nome: string;
}
// NOVO: os números do painel. Record garante que as três chaves existam.
export type Contagem = Record<Status, number>;