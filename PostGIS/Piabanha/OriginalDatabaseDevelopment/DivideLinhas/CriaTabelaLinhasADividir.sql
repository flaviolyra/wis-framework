DROP TABLE linhas_a_dividir;
CREATE TABLE linhas_a_dividir AS
SELECT id1 AS gid, nome_dre_l1 AS nome_dre,
       geom_int,
       ST_line_substring(geom_l1, 0., local1) AS geom_parte1,
       ST_line_substring(geom_l1, local1, 1.) AS geom_parte2
FROM intersecoes_sem_nos
WHERE local1 <> 1. AND local1 <> 0.;