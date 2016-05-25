CREATE OR REPLACE FUNCTION desfaz_linha(IN geom_linha geometry, IN inicial_ordem integer, IN inverte boolean)
  RETURNS TABLE(ordem integer, geom_pt geometry) AS
$BODY$

DECLARE
num_pontos integer :=  ST_NumPoints(geom_linha);

BEGIN
  IF inverte THEN
    RETURN QUERY
      SELECT inicial_ordem + num_pontos + 1 - n AS ordem, ST_PointN(geom_linha, n) AS geom_pt
      FROM generate_series(1,10000) AS n
      WHERE n <= num_pontos;
  ELSE
    RETURN QUERY
      SELECT inicial_ordem + n AS ordem, ST_PointN(geom_linha, n) AS geom_pt
      FROM generate_series(1,10000) AS n
      WHERE n <= num_pontos;
  END IF;
END;

$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100
  ROWS 1000;