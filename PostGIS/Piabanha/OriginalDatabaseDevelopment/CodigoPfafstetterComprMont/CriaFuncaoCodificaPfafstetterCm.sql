CREATE OR REPLACE FUNCTION codifica_pfafstetter_cm(codigo character varying, id_trecho integer, bacia_principal boolean)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrpsb record;
  numsb integer;
  idtrsb integer;
  idnoterm integer;
BEGIN
  -- numera cobacia em toda a bacia com codigo
  resultado := numera_bacia(codigo, id_trecho);
  numsb := 1;
  idtrsb := id_trecho;
  -- determina as confluências das bacias pares e codifica a interbacia a jusante e a subbacia
  FOR regrpsb IN
    SELECT * FROM
    (SELECT r.id_no, r.id_tr, r.compr_mont_tr, r.id_tr_afl, r.compr_mont_tr_afl FROM rio_principal_cm(codigo, id_trecho, bacia_principal, NULL) AS r
    ORDER BY r.compr_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.compr_mont_tr DESC
  LOOP
    -- codifica as interbacia a jusante da subbacia:
    resultado := codifica_interbacia_cm(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter_cm(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante - como uma bacia principal (usa codifica_pfafstetter) mas não é bacia principal (bacia_principal = FALSE)
  resultado := codifica_pfafstetter_cm(codigo || numsb, idtrsb, FALSE);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
