// A SUA função de alta ordem: recebe uma lista e uma regra
export function transformar<T, R>(lista: T[], regra: (item: T) => R): R[] {
  const resultado: R[] = [];
  for (const item of lista) {
    resultado.push(regra(item));
  }
  return resultado;
}