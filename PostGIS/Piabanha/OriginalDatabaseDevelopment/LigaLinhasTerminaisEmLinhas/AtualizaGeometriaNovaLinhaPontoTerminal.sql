UPDATE linhas_proximas_terminais SET geom_nlpt = ST_SetPoint(p.geom_lpt, 0, ST_PointN(p.geom_lo, p.ordem))
FROM pt_mais_prox_linhas_prox_terminais AS p WHERE p.gid_lo = linhas_proximas_terminais.gid_lo AND p.no_term = 'de';
UPDATE linhas_proximas_terminais SET geom_nlpt = ST_SetPoint(p.geom_lpt, ST_NumPoints(p.geom_lpt) - 1, ST_PointN(p.geom_lo, p.ordem))
FROM pt_mais_prox_linhas_prox_terminais AS p WHERE p.gid_lo = linhas_proximas_terminais.gid_lo AND p.no_term = 'para';
