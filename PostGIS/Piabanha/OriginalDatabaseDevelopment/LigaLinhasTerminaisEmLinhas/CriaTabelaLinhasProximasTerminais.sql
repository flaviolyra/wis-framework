DROP TABLE linhas_proximas_terminais CASCADE;
CREATE TABLE linhas_proximas_terminais AS
SELECT DISTINCT ON (gid_lpt) gid_lpt, no_de_lpt, no_para_lpt, no_term, geom_lpt, geom_pt, gid_lo, geom_lo
FROM
(SELECT DISTINCT ON (gid_lo) gid_lpt, no_de_lpt, no_para_lpt, no_term, geom_lpt, geom_pt, gid_lo, geom_lo
FROM linhas_proximas_linhas_terminais) AS lou