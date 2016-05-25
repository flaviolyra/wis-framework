CREATE OR REPLACE FUNCTION limmontante(codbac character varying)
  RETURNS SETOF limmont AS
$BODY$

DECLARE
limites limmont;
array_car text[] := string_to_array(codbac,NULL);
comp_array int := array_length(array_car, 1);
lim_mont bigint := rpad(codbac, 15, '0')::bigint;

BEGIN
  IF comp_array > 1 THEN
    LOOP
      IF array_car[comp_array]::int % 2 = 0 THEN
    -- algarismo é par:
        -- acrescenta o registro com o limite inferior igual ao número correspondente ao código de bacia
        -- e o limite superior com o número correspondente ao código com o primeiro algarismo par acrescido de 1, menos 1
    -- e sai
        limites.cdbacjus := rpad(codbac,15,'0')::bigint;
        array_car[comp_array] := (array_car[comp_array]::int + 1)::text;
        limites.cdbacmont := rpad(array_to_string(array_car,''),15,'0')::bigint - 1;
    RETURN NEXT limites;
        EXIT;
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