UPDATE linhas_proximas_terminais SET geom_nlo1 = ST_Line_SubString(geom_lo, 0., ST_Line_Locate_Point(geom_lo, geom_pt))
WHERE geom_nlo1 IS NULL;