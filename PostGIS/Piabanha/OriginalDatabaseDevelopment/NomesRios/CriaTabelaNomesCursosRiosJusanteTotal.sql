CREATE TABLE nomes_cursos_rios_jusante_total AS
SELECT n.gid_rio, n.gid, n.nome_dre, n.cobac_jus, n.cocurs_jus, n.area_mont_jus, n.cobac_mont, n.cocurs_mont, n.area_mont_mont,
h.nome_dre AS nome_dre_curso, h.cobacia, h.cocursodag, h.area_mont, n.fase_id_nomes FROM
(SELECT gid_rio, tr_j(cobac_mont) AS gid, nome_dre, cobac_jus, cocurs_jus, area_mont_jus, cobac_mont, cocurs_mont, area_mont_mont, fase_id_nomes
FROM nomes_rios_pontos_jus_mont) AS n
INNER JOIN hidrografia AS h ON n.gid = h.gid
ORDER BY n.gid_rio, h.area_mont DESC