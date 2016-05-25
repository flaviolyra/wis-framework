INSERT INTO nomes_rios_pontos_jusante (nome_dre, cobacia, cocursodag, area_mont)
SELECT nome_dre, cobacia, cocursodag, area_mont FROM
(SELECT DISTINCT ON (nome_dre) nome_dre, cobacia, cocursodag, area_mont FROM hidrografia WHERE nome_dre IS NOT NULL AND fase_id_nomes IS NULL
ORDER BY nome_dre, area_mont DESC) as r
ORDER BY area_mont DESC