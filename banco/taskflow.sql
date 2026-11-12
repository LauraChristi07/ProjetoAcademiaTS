SET NAMES utf8mb4;
DROP DATABASE IF EXISTS academia;
CREATE DATABASE academia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE academia;

CREATE TABLE usuarios (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha_hash CHAR(60) NOT NULL COMMENT 'hash bcrypt, NUNCA a senha',
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuarios PRIMARY KEY (id),
    CONSTRAINT uq_usuarios_email UNIQUE (email)
);

CREATE TABLE tarefas (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    descricao TEXT NULL,
    prioridade ENUM('facil', 'medio', 'dificil') NOT NULL DEFAULT 'medio',
    status ENUM('planejado', 'feito', 'pulado') NOT NULL DEFAULT 'planejado',
    prazo DATE NULL,
    criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    concluida_em DATETIME NULL,
    CONSTRAINT pk_tarefas PRIMARY KEY (id),
    CONSTRAINT fk_tarefas_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT ck_tarefas_titulo CHECK (CHAR_LENGTH(TRIM(titulo)) >= 3)
);

CREATE TABLE exercicios (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL,
    nome VARCHAR(40) NOT NULL,
    CONSTRAINT pk_exercicios PRIMARY KEY (id),
    CONSTRAINT uq_exercicios_usuario_nome UNIQUE (usuario_id, nome),
    CONSTRAINT fk_exercicios_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
);

CREATE TABLE tarefa_exercicio (
    tarefa_id INT UNSIGNED NOT NULL,
    exercicio_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_tarefa_exercicio PRIMARY KEY (tarefa_id, exercicio_id),
    CONSTRAINT fk_tarefa_exercicio_tarefa FOREIGN KEY (tarefa_id) REFERENCES tarefas (id) ON DELETE CASCADE,
    CONSTRAINT fk_tarefa_exercicio_exercicio FOREIGN KEY (exercicio_id) REFERENCES exercicios (id) ON DELETE CASCADE
);


INSERT INTO usuarios (nome, email, senha_hash) VALUES
('Ana', 'ana@email.com', 'ABCD1234');

INSERT INTO tarefas (usuario_id, titulo, prioridade, status) VALUES
(1, 'Treino cardio', 'dificil', 'feito'),

