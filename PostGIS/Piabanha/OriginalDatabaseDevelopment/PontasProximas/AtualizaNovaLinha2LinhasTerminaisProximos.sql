UPDATE linhas_terminais_proximos SET
nova_geom_linha2 = CASE WHEN ponta_linha2 = 'de' THEN ST_SetPoint(geom_linha2, 0, geom_no1)
                   ELSE ST_SetPoint(geom_linha2, ST_NumPoints(geom_linha2) - 1, geom_no1)
                   END