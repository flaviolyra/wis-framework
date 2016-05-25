CREATE OR REPLACE FUNCTION cria_arvore_cm(id_trecho integer)
  RETURNS double precision AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  comprtr double precision;
  compracum double precision;
  comprmaior double precision;
BEGIN
  SELECT h.no_de, h.no_para, h.compr INTO STRICT node, nopara, comprtr FROM hidrografia AS h WHERE h.gid = id_trecho;
  comprmaior := 0.;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
  LOOP
    compracum := cria_arvore_cm(idtrconect);
    IF compracum > comprmaior THEN comprmaior := compracum; END IF;
  END LOOP;
  INSERT INTO arvore_comprimentos (gid, no_de, no_para, compr, compracum)
  SELECT id_trecho, node, nopara, comprtr, comprtr + comprmaior;
  RETURN comprtr + comprmaior;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
