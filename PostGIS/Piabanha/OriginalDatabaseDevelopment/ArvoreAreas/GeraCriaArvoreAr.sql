CREATE OR REPLACE FUNCTION acumula_mapa(id_trecho integer)
  RETURNS SETOF caract_valor AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  i integer;
  car_val caract_valor;
  caract_valor record;
  valacum double precision[];
BEGIN
  SELECT h.no_de, h.no_para INTO STRICT node, nopara FROM hidrografia AS h WHERE h.gid = id_trecho;
  FOR i IN 1..20 LOOP valacum[i] := 0.; END LOOP;
  FOR idtrconect IN
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
    LOOP
      FOR car_val IN SELECT acumula_mapa(idtrconect)
        LOOP
          valacum[car_val.car] := valacum[car_val.car] + car_val.val;
        END LOOP;
    END LOOP;
  FOR caract_valor IN SELECT car, valor FROM mapa_trecho WHERE gid_tr = id_trecho
    LOOP
      valacum[caract_valor.car] := valacum[caract_valor.car] + caract_valor.valor;
    END LOOP;
  FOR i IN 1..20
    LOOP
      IF valacum[i] <> 0. THEN
        car_val.car := i; car_val.val := valacum[i];
        RETURN NEXT car_val;
        INSERT INTO mapa_acum_trecho (gid_tr, car, valacum)
        SELECT id_trecho, i, valacum[i];
      END IF; 
    END LOOP;
  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
