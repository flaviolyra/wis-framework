-- Function: acumula_mapa(integer)

-- DROP FUNCTION acumula_mapa(integer);

CREATE OR REPLACE FUNCTION acumula_mapa(id_trecho integer)
  RETURNS SETOF caract_valor AS
-- a partir de uma tabela contendo valores de características em áreas de contribuição e do mapa de hidrografia com informação de nós
-- gera uma tabela contendo os valores das características acumulados a montante da área, inclusive
-- entrada: tabela mapa_trecho (gid_tr, car, valor)
-- saída: tabela mapa_acum_trecho (gid_tr, car, valor)
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  i integer;
  c integer;
  v double precision;
  car_val caract_valor;
  valacum double precision[];
BEGIN
  SELECT h.no_de, h.no_para INTO STRICT node, nopara FROM hidrografia AS h WHERE h.gid = id_trecho;
  FOR i IN 1..100 LOOP valacum[i] := 0.; END LOOP;
  FOR idtrconect IN
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
    LOOP
      FOR c, v IN SELECT a.car, a.val FROM acumula_mapa(idtrconect) AS a
        LOOP
          valacum[c] := valacum[c] + v;
        END LOOP;
    END LOOP;
  FOR c, v IN SELECT car, valor FROM mapa_trecho WHERE gid_tr = id_trecho
    LOOP
      valacum[c] := valacum[c] + v;
    END LOOP;
  FOR i IN 1..100
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
  COST 100
  ROWS 1000;
ALTER FUNCTION acumula_mapa(integer)
  OWNER TO postgres;
