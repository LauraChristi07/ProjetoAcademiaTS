export type Nivel = "facil" | "medio" | "dificil";
export type Status = "planejado" | "feito" | "pulado";
export interface Tarefa {
  readonly id: number;
  titulo: string;
  descricao?: string;
  nivel: Nivel;
  status: Status;
  exercicios: string[];
  criadaEm: Date;
}
// O que o usuário informa ao cadastrar:
// id, status e criadaEm são responsabilidade do sistema
export type NovaTarefa = Omit<Tarefa, "id" | "status" | "criadaEm">;