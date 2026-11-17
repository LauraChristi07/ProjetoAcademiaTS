// =========================================================
// api/src/servidor.ts — AULA 6: tags, filtros e painel
// =========================================================
import "dotenv/config";
import bcrypt from "bcryptjs";
import express, { type NextFunction, type Request, type Response } from "express";
import jwt from "jsonwebtoken";
import type { ResultSetHeader, RowDataPacket } from "mysql2";
import { exigirLogin, SEGREDO, usuarioDe } from "./autenticacao";
import { banco } from "./banco";
import { NIVEIS, STATUS, type DadosTarefa, type Status } from "./tipos";

const app = express();
app.use(express.json());

// Consulta das tarefas com os exercícios associados
const SELECT_TAREFAS = `
  SELECT t.id, t.titulo, t.descricao, t.nivel, t.status,
         DATE_FORMAT(t.prazo, '%Y-%m-%d') AS prazo,
         t.criada_em AS criadaEm,
         (SELECT GROUP_CONCAT(g.nome ORDER BY g.nome SEPARATOR ',')
            FROM tarefa_exercicio te
            JOIN exercicios g ON g.id = te.exercicio_id
           WHERE te.tarefa_id = t.id) AS exercicios
    FROM tarefas t`;

// Transforma os exercícios em um array
function paraTarefa(linha: RowDataPacket): RowDataPacket {
  return {
    ...linha,
    exercicios: linha.exercicios ? String(linha.exercicios).split(",") : [],
  };
}

// Busca uma tarefa somente se pertencer ao usuário conectado
async function buscarUma(
  id: number,
  usuarioId: number
): Promise<RowDataPacket | undefined> {
  const [linhas] = await banco.execute<RowDataPacket[]>(
    `${SELECT_TAREFAS} WHERE t.id = ? AND t.usuario_id = ?`,
    [id, usuarioId]
  );

  return linhas.length > 0 ? paraTarefa(linhas[0]) : undefined;
}

// Valida os dados recebidos
function validar(dados: DadosTarefa): string | undefined {
  if (typeof dados.titulo !== "string" || dados.titulo.trim().length < 3) {
    return "O título precisa ter pelo menos 3 caracteres.";
  }

  if (dados.nivel !== undefined && !NIVEIS.includes(dados.nivel)) {
    return "Nível inválido.";
  }

  return undefined;
}

// ---------- LER TAREFAS ----------
app.get("/api/tarefas", exigirLogin, async (req, res) => {
  // Mostra somente as tarefas do usuário conectado
  let sql = `${SELECT_TAREFAS} WHERE t.usuario_id = ?`;
  const valores: (string | number)[] = [usuarioDe(res)];

  const { status, busca } = req.query;

  if (typeof status === "string" && STATUS.includes(status as Status)) {
    sql += " AND t.status = ?";
    valores.push(status);
  }

  if (typeof busca === "string" && busca.trim() !== "") {
    sql += " AND t.titulo LIKE ?";
    valores.push(`%${busca.trim()}%`);
  }

  sql += " ORDER BY FIELD(t.nivel, 'dificil', 'medio', 'facil'), t.titulo";

  const [linhas] = await banco.execute<RowDataPacket[]>(sql, valores);

  res.json(linhas.map(paraTarefa));
});

// ---------- LER UMA TAREFA ----------
app.get("/api/tarefas/:id", exigirLogin, async (req, res) => {
  const tarefa = await buscarUma(
    Number(req.params.id),
    usuarioDe(res)
  );

  if (!tarefa) {
    res.status(404).json({ erro: `Tarefa #${req.params.id} não encontrada.` });
    return;
  }

  res.json(tarefa);
});

// ---------- CRIAR ----------
app.post("/api/tarefas", exigirLogin, async (req, res) => {
  const dados = req.body as DadosTarefa;
  const problema = validar(dados);

  if (problema) {
    res.status(400).json({ erro: problema });
    return;
  }

  const usuarioId = usuarioDe(res);

  const [resultado] = await banco.execute<ResultSetHeader>(
    `INSERT INTO tarefas (usuario_id, titulo, descricao, nivel, prazo)
     VALUES (?, ?, ?, ?, ?)`,
    [
      usuarioId,
      dados.titulo!.trim(),
      dados.descricao ?? null,
      dados.nivel ?? "medio",
      dados.prazo || null,
    ]
  );

  res.status(201).json(
    await buscarUma(resultado.insertId, usuarioId)
  );
});

// ---------- ATUALIZAR STATUS ----------
app.patch("/api/tarefas/:id/status", exigirLogin, async (req, res) => {
  const { status } = req.body as { status?: Status };
  const usuarioId = usuarioDe(res);

  if (!status || !STATUS.includes(status)) {
    res.status(400).json({ erro: "Status inválido." });
    return;
  }

  const [resultado] = await banco.execute<ResultSetHeader>(
    `UPDATE tarefas
        SET status = ?, concluida_em = IF(? = 'feito', NOW(), NULL)
      WHERE id = ? AND usuario_id = ?`,
    [status, status, Number(req.params.id), usuarioId]
  );

  if (resultado.affectedRows === 0) {
    const tarefa = await buscarUma(Number(req.params.id), usuarioId);

    if (!tarefa) {
      res.status(404).json({ erro: `Tarefa #${req.params.id} não encontrada.` });
      return;
    }
  }

  res.status(204).end();
});

// ---------- APAGAR ----------
app.delete("/api/tarefas/:id", exigirLogin, async (req, res) => {
  const [resultado] = await banco.execute<ResultSetHeader>(
    "DELETE FROM tarefas WHERE id = ? AND usuario_id = ?",
    [Number(req.params.id), usuarioDe(res)]
  );

  if (resultado.affectedRows === 0) {
    res.status(404).json({ erro: `Tarefa #${req.params.id} não encontrada.` });
    return;
  }

  res.status(204).end();
});

// ---------- ESTATÍSTICAS ----------
app.get("/api/estatisticas", exigirLogin, async (_req, res) => {
  const [linhas] = await banco.execute<RowDataPacket[]>(
    `SELECT status, COUNT(*) AS quantidade
       FROM tarefas
      WHERE usuario_id = ?
      GROUP BY status`,
    [usuarioDe(res)]
  );

  const contagem: Record<Status, number> = {
    planejado: 0,
    pulado: 0,
    feito: 0,
  };

  for (const linha of linhas) {
    contagem[linha.status as Status] = Number(linha.quantidade);
  }

  res.json(contagem);
});

// ---------- USUÁRIOS ----------
app.post("/api/usuarios", async (req, res) => {
  const { nome, email, senha } = req.body as {
    nome?: string;
    email?: string;
    senha?: string;
  };

  if (!nome?.trim() || !email?.includes("@") || !senha || senha.length < 6) {
    res.status(400).json({
      erro: "Preencha nome, e-mail válido e senha de 6 caracteres ou mais.",
    });
    return;
  }

  const hash = await bcrypt.hash(senha, 10);

  try {
    const [resultado] = await banco.execute<ResultSetHeader>(
      "INSERT INTO usuarios (nome, email, senha_hash) VALUES (?, ?, ?)",
      [nome.trim(), email.trim().toLowerCase(), hash]
    );

    res.status(201).json({ id: resultado.insertId });
  } catch (erro) {
    if ((erro as { code?: string }).code === "ER_DUP_ENTRY") {
      res.status(409).json({ erro: "Este e-mail já está cadastrado." });
      return;
    }

    throw erro;
  }
});

// ---------- LOGIN ----------
app.post("/api/login", async (req, res) => {
  const { email, senha } = req.body as {
    email?: string;
    senha?: string;
  };

  const [linhas] = await banco.execute<RowDataPacket[]>(
    "SELECT id, nome, senha_hash FROM usuarios WHERE email = ?",
    [email?.trim().toLowerCase() ?? ""]
  );

  const usuario = linhas[0];

  if (!usuario || !senha || !(await bcrypt.compare(senha, usuario.senha_hash))) {
    res.status(401).json({ erro: "E-mail ou senha inválidos." });
    return;
  }

  const token = jwt.sign(
    { id: usuario.id },
    SEGREDO,
    { expiresIn: "8h" }
  );

  res.json({ token, nome: usuario.nome });
});

// ---------- ERROS NÃO PREVISTOS ----------
app.use((erro: unknown, _req: Request, res: Response, _next: NextFunction) => {
  console.error(erro);
  res.status(500).json({ erro: "Algo deu errado no servidor. Tente de novo." });
});

app.listen(3000, () =>
  console.log("API da academia em http://localhost:3000")
);