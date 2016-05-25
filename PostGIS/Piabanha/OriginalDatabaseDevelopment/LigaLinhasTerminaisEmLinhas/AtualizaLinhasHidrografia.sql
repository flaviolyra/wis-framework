UPDATE hidrografia SET geomproj_uni = lpt.geom_nlpt
FROM linhas_proximas_terminais AS lpt
WHERE hidrografia.gid = lpt.gid_lpt AND lpt.geom_nlpt IS NOT NULL;
UPDATE hidrografia SET geomproj_uni = lpt.geom_nlo1
FROM linhas_proximas_terminais AS lpt
WHERE hidrografia.gid = lpt.gid_lo AND lpt.geom_nlo1 IS NOT NULL;
INSERT INTO hidrografia (geomproj_uni)
SELECT geom_nlo2 FROM linhas_proximas_terminais WHERE geom_nlo2 IS NOT NULL;