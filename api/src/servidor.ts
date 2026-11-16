import "dotenv/config"; // primeira linha: carrega o .env antes de tudo
import express, { type NextFunction, type Request, type Response } from "express";
import type { ResultSetHeader, RowDataPacket } from "mysql2";
import { banco } from "./banco";
import { NIVEIS, STATUS, type DadosTarefa, type Status } from "./tipos";

const app = express();
app.use(express.json());

const USUARIO_FIXO = 1; // até a Aula 5, todo mundo é o Marcelo

const SELECT_TAREFAS = `
  SELECT id, titulo, descricao, nivel, status,
         DATE_FORMAT(prazo, '%Y-%m-%d') AS prazo,
         criada_em AS criadaEm
    FROM tarefas`;

// Busca uma tarefa pelo id. Usada pelo GET e depois de cada INSERT.
async function buscarUma(id: number): Promise<RowDataPacket | undefined> {
  const [linhas] = await banco.execute<RowDataPacket[]>(
    `${SELECT_TAREFAS} WHERE id = ? AND usuario_id = ?`,
    [id, USUARIO_FIXO]
  );
  return linhas.length > 0 ? { ...linhas[0], tags: [] } : undefined;
}

// Devolve a mensagem de erro, ou undefined se estiver tudo certo
function validar(dados: DadosTarefa): string | undefined {
  if (typeof dados.titulo !== "string" || dados.titulo.trim().length < 3) {
    return "O título precisa ter pelo menos 3 caracteres.";
  }
  if (dados.nivel !== undefined && !NIVEIS.includes(dados.nivel)) {
    return "Nível inválido.";
  }
  return undefined;
}

// ---------- LER (Aula 3) ----------
app.get("/api/tarefas", async (_req, res) => {
  const [linhas] = await banco.execute<RowDataPacket[]>(
    `${SELECT_TAREFAS} ORDER BY id`
  );
  res.json(linhas.map((linha) => ({ ...linha, tags: [] })));
});

app.get("/api/tarefas/:id", async (req, res) => {
  const tarefa = await buscarUma(Number(req.params.id));
  if (!tarefa) {
    res.status(404).json({ erro: `Tarefa #${req.params.id} não encontrada.` });
    return;
  }
  res.json(tarefa);
});

// ---------- CRIAR ----------
app.post("/api/tarefas", async (req, res) => {
  const dados = req.body as DadosTarefa;
  const problema = validar(dados);
  if (problema) {
    res.status(400).json({ erro: problema }); // 400: o pedido veio errado
    return;
  }
  const [resultado] = await banco.execute<ResultSetHeader>(
    `INSERT INTO tarefas (usuario_id, titulo, descricao, nivel, prazo)
     VALUES (?, ?, ?, ?, ?)`,
    [
      USUARIO_FIXO,
      dados.titulo!.trim(),
      dados.descricao ?? null,
      dados.nivel ?? "medio",
      dados.prazo || null,
    ]
  );
  // 201: criado. Devolve a tarefa como o banco a guardou (com id e data)
  res.status(201).json(await buscarUma(resultado.insertId));
});

// ---------- ATUALIZAR (só o status) ----------
app.patch("/api/tarefas/:id/status", async (req, res) => {
  const { status } = req.body as { status?: Status };
  if (!status || !STATUS.includes(status)) {
    res.status(400).json({ erro: "Status inválido." });
    return;
  }
  const [resultado] = await banco.execute<ResultSetHeader>(
    `UPDATE tarefas
        SET status = ?, concluida_em = IF(? = 'feito', NOW(), NULL)
      WHERE id = ? AND usuario_id = ?`,
    [status, status, Number(req.params.id), USUARIO_FIXO]
  );
  if (resultado.affectedRows === 0) {
    res.status(404).json({ erro: `Tarefa #${req.params.id} não encontrada.` });
    return;
  }
  res.status(204).end(); // 204: deu certo, e não há nada para devolver
});

// ---------- APAGAR ----------
app.delete("/api/tarefas/:id", async (req, res) => {
  const [resultado] = await banco.execute<ResultSetHeader>(
    "DELETE FROM tarefas WHERE id = ? AND usuario_id = ?",
    [Number(req.params.id), USUARIO_FIXO]
  );
  if (resultado.affectedRows === 0) {
    res.status(404).json({ erro: `Tarefa #${req.params.id} não encontrada.` });
    return;
  }
  res.status(204).end();
});

// ---------- ERROS NÃO PREVISTOS: sempre depois de todas as rotas ----------
app.use((erro: unknown, _req: Request, res: Response, _next: NextFunction) => {
  console.error(erro); // o detalhe técnico fica só no terminal
  res.status(500).json({ erro: "Algo deu errado no servidor. Tente de novo." });
});

app.listen(3000, () => console.log("API da Academia em http://localhost:3000"));