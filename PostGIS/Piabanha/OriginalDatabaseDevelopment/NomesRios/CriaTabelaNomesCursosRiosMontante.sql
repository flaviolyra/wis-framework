CREATE TABLE nomes_cursos_rios_montante AS
SELECT n.gid_rio, n.gid, n.nome_dre, n.cobac_jus, n.cocurs_jus, n.area_mont_jus, h.cobacia, h.cocursodag, h.area_mont FROM
(SELECT gid_rio, tr_m(cobacia) AS gid, nome_dre, cobacia AS cobac_jus, cocursodag AS cocurs_jus, area_mont AS area_mont_jus FROM nomes_rios_pontos_jusante
WHERE fase_id_nomes IS NULL) AS n
INNER JOIN hidrografia AS h ON n.gid = h.gid AND n.nome_dre = h.nome_dre
ORDER BY n.gid_rio, h.area_mont