CREATE OR REPLACE FUNCTION bacia_montante(codbac character varying)
  RETURNS SETOF bacmont AS
$BODY$
BEGIN
    RETURN QUERY SELECT codbac, ST_Union(geomproj) AS bac
    FROM area_contrib_eq AS a INNER JOIN limmontante(codbac) AS l
    ON a.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
