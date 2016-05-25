CREATE OR REPLACE FUNCTION tr_jd(codbac character varying, dist double precision)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limjusantei(codbac) AS l
    ON (h.cocursodag = l.crpagua AND h.cobacianum < l.cdbacmont)
    WHERE nudistbact < dist - 0.001;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;