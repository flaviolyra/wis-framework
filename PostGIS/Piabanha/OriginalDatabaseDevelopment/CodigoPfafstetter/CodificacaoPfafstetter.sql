CREATE OR REPLACE FUNCTION codifica_pfafstetter(codigo character varying, id_trecho integer, bacia_principal boolean)
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
    (SELECT r.id_no, r.id_tr, r.area_mont_tr, r.id_tr_afl, r.area_mont_tr_afl FROM rio_principal(codigo, id_trecho, bacia_principal, NULL) AS r
    ORDER BY r.area_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.area_mont_tr DESC
  LOOP
    -- codifica as interbacia a jusante da subbacia:
    resultado := codifica_interbacia(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante - como uma bacia principal (usa codifica_pfafstetter) mas não é bacia principal (bacia_principal = FALSE)
  resultado := codifica_pfafstetter(codigo || numsb, idtrsb, FALSE);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



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



CREATE OR REPLACE FUNCTION rio_principal(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer)
  RETURNS SETOF rioprinc AS
$BODY$
DECLARE
  node integer;
  nodetr integer;
  tr record;
  tr_rp rioprinc;
  idtr integer;
  idafl integer;
  areamonttr double precision;
  areamontafl double precision;
  numtrechos integer;
BEGIN
  IF bacia_principal THEN UPDATE hidrografia SET cocursodag = codigo WHERE gid = id_trecho; END IF;
  SELECT no_de INTO STRICT node FROM hidrografia WHERE gid = id_trecho;
  LOOP
    IF NOT bacia_principal AND node = id_no_limite THEN RETURN; END IF;
    numtrechos = 0;
    FOR tr IN SELECT * FROM hidrografia WHERE no_para = node ORDER BY area_mont DESC
    LOOP
      IF numtrechos = 0 THEN
    idtr := tr.gid;
    areamonttr := tr.area_mont;
    nodetr := tr.no_de;
      ELSE
    idafl := tr.gid;
    areamontafl := tr.area_mont;
      END IF;
      numtrechos := numtrechos + 1;
    END LOOP;
    IF numtrechos = 0 THEN RETURN; END IF;
    tr_rp.id_no := node;
    tr_rp.id_tr := idtr;
    tr_rp.area_mont_tr := areamonttr;
    tr_rp.id_tr_afl := idafl;
    tr_rp.area_mont_tr_afl := areamontafl;
    node := nodetr;
    RETURN NEXT tr_rp;
    IF bacia_principal THEN UPDATE hidrografia SET cocursodag = codigo WHERE gid = idtr; END IF;
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



CREATE TYPE rioprinc AS
   (id_no integer,
    id_tr integer,
    area_mont_tr double precision,
    id_tr_afl integer,
    area_mont_tr_afl double precision);
