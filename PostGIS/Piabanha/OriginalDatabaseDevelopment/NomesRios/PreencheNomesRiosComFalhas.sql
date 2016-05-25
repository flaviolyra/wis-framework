UPDATE hidrografia SET nome_dre = n.nome_dre FROM
(SELECT * FROM nomes_cursos_rios_jusante WHERE nome_dre_curso IS NULL ORDER BY gid_rio, area_mont DESC) as n
WHERE n.gid = hidrografia.gid