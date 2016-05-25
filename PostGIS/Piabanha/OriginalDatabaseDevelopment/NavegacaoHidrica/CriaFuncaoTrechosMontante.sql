CREATE OR REPLACE FUNCTION trechos_montante(IN codbac character varying)
  RETURNS TABLE(
  gid integer,
  nome_dre character varying(40),
  compr double precision,
  compr_mont double precision,
  cocursodag character varying(30),
  cobacia character varying(30),
  cobacianum bigint,
  no_de integer,
  no_para integer,
  geom_uni geometry(LineString,4326),
  geomproj_uni geometry(LineString,32723)) AS
$BODY$
BEGIN
    RETURN QUERY SELECT
    h.gid,
    h.nome_dre,
    h.compr,
    h.compr_mont,
    h.cocursodag,
    h.cobacia,
    h.cobacianum,
    h.no_de,
    h.no_para,
    h.geom_uni,
    h.geomproj_uni
    FROM hidrografia AS h
    INNER JOIN limmontante(codbac) AS l
    ON h.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;