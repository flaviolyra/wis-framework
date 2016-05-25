DELETE FROM linhas_a_fundir
WHERE id_curta IN
(SELECT DISTINCT id_outra FROM linhas_a_fundir); 