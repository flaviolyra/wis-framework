UPDATE nomes_cursos_rios_jusante_total SET gid = h.gid
FROM hidrografia AS h
WHERE nomes_cursos_rios_jusante_total.cobacia = h.cobacia AND nomes_cursos_rios_jusante_total.gid IS NULL