CREATE FUNCTION tr_j(codbac character varying)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limjusante(codbac) AS l
    ON (h.cocursodag = l.crpagua AND h.cobacianum < l.cdbacmont);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;