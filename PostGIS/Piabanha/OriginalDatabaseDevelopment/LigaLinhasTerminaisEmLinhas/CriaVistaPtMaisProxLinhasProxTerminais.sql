CREATE VIEW pt_mais_prox_linhas_prox_terminais AS
SELECT * FROM
(SELECT DISTINCT ON (gid_lo)
gid_lpt, no_de_lpt, no_para_lpt, no_term, geom_lpt, geom_pt, gid_lo, geom_lo,
(desfaz_linha(geom_lo, 0, FALSE)).ordem, (desfaz_linha(geom_lo, 0, FALSE)).geom_pt AS geom_pt_lo, st_distance(geom_lpt, (desfaz_linha(geom_lo, 0, FALSE)).geom_pt) AS dist
FROM linhas_proximas_terminais
ORDER BY gid_lo, dist) AS lptdist
WHERE dist < 50.