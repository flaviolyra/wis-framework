-- Apaga tabela nos atual
DROP TABLE nos CASCADE;
-- Cria nova tabela nos
CREATE TABLE nos
(
  id serial NOT NULL,
  geom geometry(Point,4326),
  geomproj geometry(Point,32723),
  num_conex integer,
  CONSTRAINT nos_pkey PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nos_geomproj_gist
  ON nos
  USING gist
  (geomproj );
-- Gera os nos na tabela
INSERT INTO nos (geomproj)
SELECT DISTINCT ST_StartPoint(geomproj_uni) FROM hidrografia
UNION
SELECT DISTINCT ST_EndPoint(geomproj_uni) FROM hidrografia;
-- Zera no_de na hidrografia
UPDATE hidrografia SET no_de = 0;
-- Zera no_para na hidrografia
UPDATE hidrografia SET no_para = 0;
-- Atualiza no_de na hidrografia
UPDATE hidrografia SET no_de = n.id
FROM nos AS n
WHERE ST_StartPoint(hidrografia.geomproj_uni) = n.geomproj;
-- Atualiza no_para na hidrografia
UPDATE hidrografia SET no_para = n.id
FROM nos AS n
WHERE ST_EndPoint(hidrografia.geomproj_uni) = n.geomproj;