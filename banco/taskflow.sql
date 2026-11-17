SET NAMES utf8mb4;   -- garante os acentos quando o script roda pelo terminal
CREATE DATABASE academia CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- MariaDB/XAMPP? troque a linha acima por:
-- CREATE DATABASE academia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE academia;

-- ---------- usuarios ----------
CREATE TABLE usuarios (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL,
  senha_hash  CHAR(60)     NOT NULL,          -- hash bcrypt, NUNCA a senha
  criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_usuarios       PRIMARY KEY (id),
  CONSTRAINT uq_usuarios_email UNIQUE (email)
);

-- ---------- tarefas (a interface Tarefa virou tabela) ----------
CREATE TABLE tarefas (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario_id     INT UNSIGNED NOT NULL,
  titulo         VARCHAR(120) NOT NULL,
  descricao      TEXT         NULL,
  nivel     ENUM('facil', 'medio', 'dificil')                NOT NULL DEFAULT 'medio',
  status         ENUM('planejado', 'pulado', 'feito') NOT NULL DEFAULT 'planejado',
  prazo          DATE         NULL,
  criada_em      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizada_em  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  feito          DATETIME     NULL,
  CONSTRAINT pk_tarefas PRIMARY KEY (id),
  CONSTRAINT fk_tarefas_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuarios (id) ON DELETE CASCADE,
  CONSTRAINT ck_tarefas_titulo CHECK (CHAR_LENGTH(TRIM(titulo)) >= 3)
);

-- ---------- exercícios (cada usuário tem os seus) ----------
CREATE TABLE exercicios (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario_id  INT UNSIGNED NOT NULL,
  nome        VARCHAR(40)  NOT NULL,
  CONSTRAINT pk_exercicios PRIMARY KEY (id),
  CONSTRAINT uq_exercicios_usuario_nome UNIQUE (usuario_id, nome),
  CONSTRAINT fk_exercicios_usuario FOREIGN KEY (usuario_id)
    REFERENCES usuarios (id) ON DELETE CASCADE
);

-- ---------- tarefa_exercicio (N:N entre tarefas e exercícios) ----------
CREATE TABLE tarefa_exercicio (
  tarefa_id  INT UNSIGNED NOT NULL,
  exercicio_id INT UNSIGNED NOT NULL,
  CONSTRAINT pk_tarefa_exercicio PRIMARY KEY (tarefa_id, exercicio_id),
  CONSTRAINT fk_tarefa_exercicio_tarefa FOREIGN KEY (tarefa_id)
    REFERENCES tarefas (id) ON DELETE CASCADE,
  CONSTRAINT fk_tarefa_exercicio_exercicio FOREIGN KEY (exercicio_id)
    REFERENCES exercicios (id) ON DELETE CASCADE
);

-- =========================================================
-- Dados de exemplo
-- Dois usuários: Ana e Bruno — senha de ambos: senha123
-- (o texto abaixo é o HASH bcrypt de "senha123", não a senha)

-- 0) Limpar os registros anteriores
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM tarefa_exercicio;
DELETE FROM tarefas;
DELETE FROM exercicios;
DELETE FROM usuarios;

-- Reiniciar os IDs
ALTER TABLE tarefas AUTO_INCREMENT = 1;
ALTER TABLE exercicios AUTO_INCREMENT = 1;
ALTER TABLE usuarios AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

SET NAMES utf8mb4;
USE academia;

-- 1) Apaga os treinos da Ana
-- As ligações com exercícios saem junto (ON DELETE CASCADE)
DELETE FROM tarefas WHERE usuario_id = 1;

-- 2) Seis treinos novos para a Ana
INSERT INTO tarefas (usuario_id, titulo, descricao, nivel, status, prazo) VALUES
(1, 'Treino de pernas',  'Foco em quadríceps',       'dificil', 'feito',     '2026-11-20'),
(1, 'Treino de braços', 'Bíceps e tríceps',         'medio',   'planejado', '2026-11-21'),
(1, 'Treino de peito',  'Peitoral e resistência',   'medio',   'planejado', NULL),
(1, 'Treino de glúteos','Fortalecimento muscular', 'facil',   'planejado', NULL),
(1, 'Treino de costas', 'Postura e fortalecimento','dificil', 'planejado', '2026-11-25'),
(1, 'Treino funcional','Condicionamento físico',   'medio',   'pulado',    NULL);

-- 3) Os exercícios dos treinos, ligados pelo nome
INSERT INTO tarefa_exercicio (tarefa_id, exercicio_id)
SELECT t.id, e.id
  FROM tarefas t
  JOIN exercicios e ON e.usuario_id = t.usuario_id
 WHERE t.usuario_id = 1
   AND (   (t.titulo = 'Treino de pernas' AND e.nome IN ('Agachamento livre', 'Leg press', 'Cadeira extensora'))
        OR (t.titulo = 'Treino de braços' AND e.nome IN ('Rosca direta', 'Tríceps com barra', 'Rosca martelo'))
        OR (t.titulo = 'Treino de peito' AND e.nome IN ('Supino', 'Crucifixo'))
        OR (t.titulo = 'Treino de glúteos' AND e.nome IN ('Agachamento livre', 'Leg press'))
        OR (t.titulo = 'Treino de costas' AND e.nome IN ('Agachamento livre', 'Cadeira extensora'))
        OR (t.titulo = 'Treino funcional' AND e.nome IN ('Agachamento livre', 'Rosca direta')));

-- 4) Confira: planejado 4, feito 1, pulado 1
SELECT status, COUNT(*) AS quantidade
FROM tarefas
WHERE usuario_id = 1
GROUP BY status;
SELECT * FROM tarefas;
SELECT * FROM exercicios;
SELECT * FROM tarefa_exercicio;
SELECT * FROM usuarios;

