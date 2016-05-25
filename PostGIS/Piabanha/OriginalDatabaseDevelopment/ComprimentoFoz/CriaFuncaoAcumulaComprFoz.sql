CREATE OR REPLACE FUNCTION acumula_compr_foz(id_trecho integer, compr double precision)
  RETURNS integer AS
$BODY$
DECLARE
  node integer;
  comptr double precision;
  idtrconect integer;
  resultado integer;
BEGIN
  SELECT h.no_de, h.compr INTO STRICT node, comptr FROM hidrografia AS h WHERE h.gid = id_trecho;
  INSERT INTO compr_foz VALUES (id_trecho, compr);
  FOR idtrconect IN
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
    LOOP
      resultado = acumula_compr_foz(idtrconect, compr + comptr);
    END LOOP;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
