CREATE OR REPLACE FUNCTION limjusantei(codbac character varying)
  RETURNS SETOF limjus AS
$BODY$

DECLARE
limites limjus;
array_car text[] := string_to_array(codbac,NULL);
comp_array int := array_length(array_car, 1);
lim_mont bigint := rpad(codbac, 15, '0')::bigint + 1;

BEGIN
  IF comp_array > 1 THEN
    LOOP
      IF array_car[comp_array]::int % 2 = 0 THEN
    -- algarismo é par:
        -- acrescenta à matriz o código do rio como string
        -- acrescenta à matriz o limite montante - faz novo limite igual a número correspondente ao código do rio
        limites.crpagua := array_to_string(array_car,'');
        limites.cdbacmont := lim_mont;
       RETURN NEXT limites;
        lim_mont := rpad(array_to_string(array_car,''), 15, '0')::bigint;
      END IF;
      comp_array := comp_array - 1;
      array_car := array_car[1:comp_array];
      IF comp_array = 0 THEN EXIT; 
      END IF;
    END LOOP;
  END IF;
  RETURN;
END;

$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100
  ROWS 1000;
