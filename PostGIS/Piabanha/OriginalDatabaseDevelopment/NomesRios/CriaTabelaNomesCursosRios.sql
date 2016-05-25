CREATE TABLE nomes_cursos_rios AS
SELECT * FROM nomes_cursos_rios_jusante_total WHERE nome_dre = nome_dre_curso ORDER BY gid_rio, area_mont DESC