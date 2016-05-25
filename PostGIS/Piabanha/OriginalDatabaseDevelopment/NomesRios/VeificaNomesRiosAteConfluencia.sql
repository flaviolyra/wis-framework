SELECT * FROM nomes_cursos_rios_jusante_total WHERE nome_dre = 'Rio Preto' AND (nome_dre_curso IS NULL OR nome_dre_curso = 'Centerline' )
ORDER BY area_mont DESC