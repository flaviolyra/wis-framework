UPDATE linhas_proximas_terminais
SET geom_nlpt = ST_SetPoint(geom_lpt, 0, ST_Line_Interpolate_Point(geom_lo, ST_Line_Locate_Point(geom_lo, geom_pt)))
WHERE no_term = 'de' AND geom_nlpt IS NULL;
UPDATE linhas_proximas_terminais
SET geom_nlpt = ST_SetPoint(geom_lpt, ST_NumPoints(geom_lpt) - 1, ST_Line_Interpolate_Point(geom_lo, ST_Line_Locate_Point(geom_lo, geom_pt)))
WHERE no_term = 'para' AND geom_nlpt IS NULL;
