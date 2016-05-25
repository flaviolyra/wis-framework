DELETE FROM hidrografia
WHERE gid IN
(SELECT id_curta FROM linhas_a_fundir);