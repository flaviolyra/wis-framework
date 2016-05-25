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
