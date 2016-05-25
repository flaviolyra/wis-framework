UPDATE estende_linhas SET geom_estendida =
                CASE WHEN ponta = 'de' THEN ST_AddPoint(geom_linha, geom_no, 0)
                ELSE ST_AddPoint(geom_linha, geom_no, -1)
                END;