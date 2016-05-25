CREATE OR REPLACE FUNCTION codifica_interbacia(codigo character varying, id_trecho integer, id_no_limite integer)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrpsb record;
  numsb integer;
  idtrsb integer;
BEGIN
  -- numera toda a interbacia com codigo
  resultado := numera_interbacia(codigo, id_trecho, id_no_limite);
  numsb := 1;
  idtrsb := id_trecho;
  FOR regrpsb IN
    SELECT * FROM
    (SELECT r.id_no, r.id_tr, r.area_mont_tr, r.id_tr_afl, r.area_mont_tr_afl FROM rio_principal(codigo, id_trecho, FALSE, id_no_limite) AS r
    ORDER BY r.area_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.area_mont_tr DESC
  LOOP
    -- codifica a interbacia antes da subbacia:
    resultado := codifica_interbacia(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante
  resultado := codifica_interbacia(codigo || numsb, idtrsb, id_no_limite);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
