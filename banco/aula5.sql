USE academia;
UPDATE usuarios
SET senha_hash = '1234'
WHERE id IN (1, 2, 3);
-- Confira: os três têm o mesmo hash (foi copiado, não gerado três vezes)
SELECT id, nome, email, senha_hash FROM usuarios
