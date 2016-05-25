CREATE OR REPLACE FUNCTION numera_interbacia(codigo character varying, id_trecho integer, id_no_limite integer)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrp record;
BEGIN
  -- numera o primeiro trecho
  UPDATE hidrografia SET cobacia = codigo WHERE gid = id_trecho;
  FOR regrp IN 
    SELECT r.id_no, r.id_tr, r.area_mont_tr, r.id_tr_afl, r.area_mont_tr_afl FROM rio_principal(codigo, id_trecho, FALSE, id_no_limite) AS r
    ORDER BY r.area_mont_tr_afl DESC
  LOOP
    -- numera o trecho montante:
    UPDATE hidrografia SET cobacia = codigo WHERE gid = regrp.id_tr;
    -- numera a bacia afluente
    resultado := numera_bacia(codigo, regrp.id_tr_afl);
  END LOOP;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
