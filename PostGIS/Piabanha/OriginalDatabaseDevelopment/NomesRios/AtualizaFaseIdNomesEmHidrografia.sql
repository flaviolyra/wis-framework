UPDATE hidrografia SET fase_id_nomes = n.fase_id_nomes
FROM nomes_cursos_rios AS n WHERE hidrografia.gid = n.gid