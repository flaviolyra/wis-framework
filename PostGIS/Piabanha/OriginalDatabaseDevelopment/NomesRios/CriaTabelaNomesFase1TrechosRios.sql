CREATE TABLE nomes_fase1_trechos_rios AS
SELECT DISTINCT gid FROM nomes_cursos_rios_jusante_total WHERE fase_id_nomes = 1
ORDER BY gid