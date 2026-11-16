SET NAMES utf8mb4;   -- garante os acentos quando o script roda pelo terminal
DROP DATABASE IF EXISTS academia;
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
  concluida_em   DATETIME     NULL,
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

-- 1) Usuários
INSERT INTO usuarios (nome, email, senha_hash) VALUES
('Ana', 'ana@email.com', 'ABCD1234'),
('Bruno', 'bruno@email.com', 'EFGH5678'),
('Carla', 'carla@email.com', 'IJKL9012');

-- 2) Exercícios
INSERT INTO exercicios (usuario_id, nome) VALUES
(1, 'Agachamento livre'),
(1, 'Leg press'),
(1, 'Cadeira extensora'),

(2, 'Stiff'),
(2, 'Agachamento búlgaro'),
(2, 'Elevação pélvica'),

(3, 'Corrida'),
(3, 'Bicicleta'),
(3, 'Esteira'),

(1, 'Rosca direta'),
(1, 'Tríceps com barra'),
(1, 'Rosca martelo'),

(2, 'Supino'),
(2, 'Crucifixo'),
(2, 'Pullover'),

(3, 'Remada curvada'),
(3, 'Remada baixa'),
(3, 'Puxada alta');

-- 3) Treinos
INSERT INTO tarefas (usuario_id, titulo, descricao, nivel, status, prazo) VALUES
(1, 'Treino de pernas', 'PR #42', 'medio', 'pulado', NULL),
(2, 'Treino de glúteos', NULL, 'facil', 'pulado', NULL),
(3, 'Treino de cardio', 'PR #42', 'medio', 'feito', NULL);

-- 4) Ligação treino ↔ exercício
INSERT INTO tarefa_exercicio (tarefa_id, exercicio_id) VALUES
(1, 1),
(2, 2),
(3, 3);

SELECT * FROM tarefas;
SELECT * FROM exercicios;
SELECT * FROM tarefa_exercicio;
SELECT * FROM usuarios;