CREATE FUNCTION tr_m(codbac character varying)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limmontante(codbac) AS l
    ON h.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

