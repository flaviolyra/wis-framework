-- Elimina Tabela linhas_terminais_proximos

DROP TABLE linhas_terminais_proximos;

-- Cria Tabela linhas_terminais_proximos

CREATE TABLE linhas_terminais_proximos AS
SELECT * FROM linhas12_nos_terminais_proximos
WHERE compr_linha1 < compr_linha2;

-- Acrescenta gemoetria nova linha a linhas_terminais_proximos

ALTER TABLE linhas_terminais_proximos ADD nova_geom_linha2 geometry(Linestring, 32723);

-- Atualiza nova linha2

UPDATE linhas_terminais_proximos SET
nova_geom_linha2 = CASE WHEN ponta_linha2 = 'de' THEN ST_SetPoint(geom_linha2, 0, geom_no1)
                   ELSE ST_SetPoint(geom_linha2, ST_NumPoints(geom_linha2) - 1, geom_no1)
                   END;
