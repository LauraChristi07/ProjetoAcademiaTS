export type Nivel = "facil" | "medio" | "dificil";
export type Status = "planejado" | "feito" | "pulado";

export const NIVEIS: Nivel[] = ["facil", "medio", "dificil"];
export const STATUS: Status[] = ["planejado", "feito", "pulado"];

// O que chega no corpo do POST. Tudo é opcional porque quem
// manda é o navegador: a API confere antes de usar.
export interface DadosTarefa {
  titulo?: string;
  descricao?: string | null;
  nivel?: Nivel;
  prazo?: string | null;
  exercicios?: string[];
}
