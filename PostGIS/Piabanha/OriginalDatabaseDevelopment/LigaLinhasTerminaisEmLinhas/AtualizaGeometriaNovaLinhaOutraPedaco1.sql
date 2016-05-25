UPDATE linhas_proximas_terminais SET geom_nlo1 = l1.geom_lo
FROM
(SELECT gid_lo, ST_MakeLine(pl1.geom_pt) AS geom_lo
FROM
(SELECT gid_lo, numptlim, ordem, geom_pt FROM
(SELECT gid_lo, ordem AS numptlim, (desfaz_linha(p.geom_lo, 0, FALSE)).ordem, (desfaz_linha(p.geom_lo, 0, FALSE)).geom_pt
FROM pt_mais_prox_linhas_prox_terminais AS p) as pl
WHERE ordem <= numptlim
ORDER BY gid_lo, ordem) AS pl1
GROUP BY gid_lo) AS l1
WHERE linhas_proximas_terminais.gid_lo = l1.gid_lo