CREATE OR REPLACE FUNCTION tr_md(codbac character varying, dist double precision)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limmontante(codbac) AS l
    ON h.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont
    WHERE h.nudistbact > dist - 0.001;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

