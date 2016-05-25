UPDATE linhas_proximas_terminais SET geom_nlo2 = ST_Line_SubString(geom_lo, ST_Line_Locate_Point(geom_lo, geom_pt), 1.)
WHERE geom_nlo2 IS NULL;