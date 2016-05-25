CREATE OR REPLACE FUNCTION numera_bacia(codigo varchar(30), id_trecho integer)
RETURNS integer AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  resultado integer;
BEGIN
  SELECT h.no_de, h.no_para INTO STRICT node, nopara FROM hidrografia AS h WHERE h.gid = id_trecho;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
  LOOP
    resultado := numera_bacia(codigo, idtrconect);
  END LOOP;
  UPDATE hidrografia SET cobacia = codigo
  WHERE gid = id_trecho;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
