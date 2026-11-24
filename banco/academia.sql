-- ============================================
-- PROJETO ACADEMIA
-- Banco de dados: academia
-- ============================================

SET NAMES utf8mb4;
CREATE DATABASE academia
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE academia;


-- ============================================
-- 1) TABELA: USUARIOS
-- ============================================

CREATE TABLE usuarios (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha_hash CHAR(60) NOT NULL COMMENT 'Hash bcrypt, NUNCA a senha',
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuarios PRIMARY KEY (id),
    CONSTRAINT uq_usuarios_email UNIQUE (email)
);


-- ============================================
-- 2) TABELA: TAREFAS
-- Cada usuário possui suas próprias 6 tarefas.
-- ============================================

CREATE TABLE tarefas (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    descricao TEXT NULL,
    nivel ENUM('facil', 'medio', 'dificil') NOT NULL DEFAULT 'medio',
    status ENUM('planejado', 'feito', 'pulado') NOT NULL DEFAULT 'planejado',
    prazo DATE NULL,
    criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    concluida_em DATETIME NULL,

    CONSTRAINT pk_tarefas PRIMARY KEY (id),

    CONSTRAINT fk_tarefas_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id)
        ON DELETE CASCADE,

    CONSTRAINT ck_tarefas_titulo
        CHECK (CHAR_LENGTH(TRIM(titulo)) >= 3)
);


-- ============================================
-- 3) TABELA: EXERCICIOS
-- Os mesmos 18 exercícios são compartilhados.
-- ============================================

CREATE TABLE exercicios (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,

    CONSTRAINT pk_exercicios PRIMARY KEY (id),
    CONSTRAINT uq_exercicios_nome UNIQUE (nome)
);


-- ============================================
-- 4) TABELA: TAREFA_EXERCICIO
-- Relaciona cada tarefa aos exercícios.
-- ============================================

CREATE TABLE tarefa_exercicio (
    tarefa_id INT UNSIGNED NOT NULL,
    exercicio_id INT UNSIGNED NOT NULL,

    CONSTRAINT pk_tarefa_exercicio
        PRIMARY KEY (tarefa_id, exercicio_id),

    CONSTRAINT fk_tarefa_exercicio_tarefa
        FOREIGN KEY (tarefa_id)
        REFERENCES tarefas (id)
        ON DELETE CASCADE,

    CONSTRAINT fk_tarefa_exercicio_exercicio
        FOREIGN KEY (exercicio_id)
        REFERENCES exercicios (id)
        ON DELETE CASCADE
);


-- ============================================
-- 5) INSERÇÃO DOS USUÁRIOS
-- ============================================

INSERT INTO usuarios (nome, email, senha_hash) VALUES
('Ana', 'ana@email.com', '$2b$10$yGSAa/gEq/tG7Wt.Tzto/eedr6AZi.sJayl9I9WCerOOerGPI9fqi'),
('Bruno', 'bruno@email.com', '$2b$10$8SKHHGou2gRrIMSAgA7bCuOtOojuGqtjuJ6mzNYBpTbF7GSLo0Q76'),
('Carla', 'carla@email.com', '$2b$10$pMxotPtc/QVx7aiY.9hi/ua81D/gXP0vLilKledT2cTPA7fg4wFBq'),
('Laura', 'laura@email.com', '$2b$10$.9h55j2DWScLPZ.A2kgOjOKw9dTCbnnK.Gu1syEUKOrgPj/L9Pyp2'),
('Julia', 'julia@email.com', '$2b$10$AW6Uok8w4Z.L7IJr4qqL3./juXnEypYamo.jK7SX3UQtJkeZCxyL2'),
('Diogo', 'diogo@email.com', '$2b$10$wbZ75xvh3ZBQkmVMtv/G.udLR2bEiMP9WW8VuWibnbnjZ2rj/c1Ra');


-- ============================================
-- 6) INSERÇÃO DOS EXERCÍCIOS COMPARTILHADOS
-- ============================================

INSERT INTO exercicios (nome) VALUES

-- Treino de Pernas
('Agachamento livre'),
('Leg press'),
('Cadeira extensora'),

-- Treino de Glúteos
('Stiff'),
('Agachamento búlgaro'),
('Elevação pélvica'),

-- Treino de Cardio
('Corrida'),
('Bicicleta'),
('Esteira'),

-- Treino de Braços
('Rosca direta'),
('Tríceps com barra'),
('Rosca martelo'),

-- Treino de Peito
('Supino'),
('Crucifixo'),
('Pullover'),

-- Treino de Costas
('Remada curvada'),
('Remada baixa'),
('Puxada alta');


-- ============================================
-- 7) INSERÇÃO DAS 6 TAREFAS PARA CADA USUÁRIO
-- Total: 36 tarefas
-- ============================================

INSERT INTO tarefas (usuario_id, titulo, nivel, status)
VALUES

-- Ana
(1, 'Treino de Pernas', 'medio', 'planejado'),
(1, 'Treino de Glúteos', 'facil', 'planejado'),
(1, 'Treino de Cardio', 'medio', 'planejado'),
(1, 'Treino de Braços', 'facil', 'planejado'),
(1, 'Treino de Peito', 'medio', 'planejado'),
(1, 'Treino de Costas', 'dificil', 'planejado'),

-- Bruno
(2, 'Treino de Pernas', 'medio', 'planejado'),
(2, 'Treino de Glúteos', 'facil', 'planejado'),
(2, 'Treino de Cardio', 'medio', 'planejado'),
(2, 'Treino de Braços', 'facil', 'planejado'),
(2, 'Treino de Peito', 'medio', 'planejado'),
(2, 'Treino de Costas', 'dificil', 'planejado'),

-- Carla
(3, 'Treino de Pernas', 'medio', 'planejado'),
(3, 'Treino de Glúteos', 'facil', 'planejado'),
(3, 'Treino de Cardio', 'medio', 'planejado'),
(3, 'Treino de Braços', 'facil', 'planejado'),
(3, 'Treino de Peito', 'medio', 'planejado'),
(3, 'Treino de Costas', 'dificil', 'planejado'),

-- Laura
(4, 'Treino de Pernas', 'medio', 'planejado'),
(4, 'Treino de Glúteos', 'facil', 'planejado'),
(4, 'Treino de Cardio', 'medio', 'planejado'),
(4, 'Treino de Braços', 'facil', 'planejado'),
(4, 'Treino de Peito', 'medio', 'planejado'),
(4, 'Treino de Costas', 'dificil', 'planejado'),

-- Julia
(5, 'Treino de Pernas', 'medio', 'planejado'),
(5, 'Treino de Glúteos', 'facil', 'planejado'),
(5, 'Treino de Cardio', 'medio', 'planejado'),
(5, 'Treino de Braços', 'facil', 'planejado'),
(5, 'Treino de Peito', 'medio', 'planejado'),
(5, 'Treino de Costas', 'dificil', 'planejado'),

-- Diogo
(6, 'Treino de Pernas', 'medio', 'planejado'),
(6, 'Treino de Glúteos', 'facil', 'planejado'),
(6, 'Treino de Cardio', 'medio', 'planejado'),
(6, 'Treino de Braços', 'facil', 'planejado'),
(6, 'Treino de Peito', 'medio', 'planejado'),
(6, 'Treino de Costas', 'dificil', 'planejado');


-- ============================================
-- 8) RELACIONAMENTO ENTRE TAREFAS E EXERCÍCIOS
-- Cada usuário terá os mesmos exercícios.
-- ============================================

INSERT INTO tarefa_exercicio (tarefa_id, exercicio_id)
VALUES

-- Ana
(1,1), (1,2), (1,3),
(2,4), (2,5), (2,6),
(3,7), (3,8), (3,9),
(4,10), (4,11), (4,12),
(5,13), (5,14), (5,15),
(6,16), (6,17), (6,18),

-- Bruno
(7,1), (7,2), (7,3),
(8,4), (8,5), (8,6),
(9,7), (9,8), (9,9),
(10,10), (10,11), (10,12),
(11,13), (11,14), (11,15),
(12,16), (12,17), (12,18),

-- Carla
(13,1), (13,2), (13,3),
(14,4), (14,5), (14,6),
(15,7), (15,8), (15,9),
(16,10), (16,11), (16,12),
(17,13), (17,14), (17,15),
(18,16), (18,17), (18,18),

-- Laura
(19,1), (19,2), (19,3),
(20,4), (20,5), (20,6),
(21,7), (21,8), (21,9),
(22,10), (22,11), (22,12),
(23,13), (23,14), (23,15),
(24,16), (24,17), (24,18),

-- Julia
(25,1), (25,2), (25,3),
(26,4), (26,5), (26,6),
(27,7), (27,8), (27,9),
(28,10), (28,11), (28,12),
(29,13), (29,14), (29,15),
(30,16), (30,17), (30,18),

-- Diogo
(31,1), (31,2), (31,3),
(32,4), (32,5), (32,6),
(33,7), (33,8), (33,9),
(34,10), (34,11), (34,12),
(35,13), (35,14), (35,15),
(36,16), (36,17), (36,18);


-- ============================================
-- 9) CONSULTAS PARA CONFERÊNCIA
-- ============================================

SELECT * FROM usuarios;

SELECT * FROM tarefas ORDER BY usuario_id, id;

SELECT * FROM exercicios;

SELECT * FROM tarefa_exercicio ORDER BY tarefa_id;

-- Total de tarefas por usuário
SELECT usuario_id, COUNT(*) AS total_tarefas
FROM tarefas
GROUP BY usuario_id
ORDER BY usuario_id;

-- Total de exercícios
SELECT COUNT(*) AS total_exercicios
FROM exercicios;

-- Total de relacionamentos
SELECT COUNT(*) AS total_relacionamentos
FROM tarefa_exercicio;