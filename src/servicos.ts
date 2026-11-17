import type { Contagem, Nivel, Status, Tarefa } from "./tipos";
// ---------- filter e find: selecionar ----------
export function filtrarPorStatus(lista: Tarefa[], status: Status): Tarefa[] {
return lista.filter((t) => t.status === status);
}
// Pesquisa sem diferenciar maiúsculas de minúsculas
export function pesquisarPorTitulo(lista: Tarefa[], termo: string): Tarefa[] {
const procurado = termo.trim().toLowerCase();
return lista.filter((t) => t.titulo.toLowerCase().includes(procurado));
}
// ---------- some e every: perguntas de sim ou não ----------
export function existeDificilPlanejado(lista: Tarefa[]): boolean {
return lista.some((t) => t.nivel === "dificil" && t.status === "planejado");
}
export function todasFeitas(lista: Tarefa[]): boolean {
return lista.length > 0 && lista.every((t) => t.status === "feito");
}
// ---------- reduce: o painel calculado no navegador ----------
export function contarPorStatus(lista: Tarefa[]): Contagem {
return lista.reduce<Contagem>(
(acumulador, t) => {
acumulador[t.status]++;
return acumulador; // não esqueça este return!
},
{ planejado: 0, pulado: 0, feito: 0 }
);
}
// ---------- sort: ordenar sem estragar o original ----------
const pesoNivel: Record<Nivel, number> = { facil: 3, medio: 2, dificil: 1 };
export function ordenarPorNivel(lista: Tarefa[]): Tarefa[] {
return [...lista].sort(
(a, b) => pesoNivel[b.nivel] - pesoNivel[a.nivel]
);
}