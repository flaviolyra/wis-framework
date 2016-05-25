CREATE OR REPLACE FUNCTION une_linhas(linha1 geometry, linha2 geometry)
  RETURNS geometry AS
$BODY$
DECLARE
  pt_in_1 geometry(point) := ST_StartPoint(linha1);
  pt_fn_1 geometry(point) := ST_EndPoint(linha1);
  pt_in_2 geometry(point) := ST_StartPoint(linha2);
  pt_fn_2 geometry(point) := ST_EndPoint(linha2);
  linha2r geometry(Linestring); 
  npt1 integer := ST_NumPoints(linha1);
  npt2 integer := ST_NumPoints(linha2);
  inicial integer;
  inverte boolean;
BEGIN
  IF npt2 = 2 THEN
    CASE
      WHEN ST_Equals(pt_in_1, pt_in_2) THEN
 	RETURN ST_AddPoint(linha1, pt_fn_2, 0);
      WHEN ST_Equals(pt_in_1, pt_fn_2) THEN
 	RETURN ST_AddPoint(linha1, pt_in_2, 0);
      WHEN ST_Equals(pt_fn_1, pt_in_2) THEN
 	RETURN ST_AddPoint(linha1, pt_fn_2, -1);
      WHEN ST_Equals(pt_fn_1, pt_fn_2) THEN
 	RETURN ST_AddPoint(linha1, pt_in_2, -1);
      ELSE
 	RETURN NULL;
      END CASE;
ELSE
    CASE
      WHEN ST_Equals(pt_in_1, pt_in_2) THEN
        linha2r := ST_RemovePoint(linha2, 0);
	inicial := - npt1;
   	inverte := TRUE;
      WHEN ST_Equals(pt_in_1, pt_fn_2) THEN
	linha2r := ST_RemovePoint(linha2, npt2 - 1);
	inicial := npt2 - 1;
	inverte := FALSE;
      WHEN ST_Equals(pt_fn_1, pt_in_2) THEN
	linha2r := ST_RemovePoint(linha2, 0);
	inicial := - npt1;
	inverte := FALSE;
      WHEN ST_Equals(pt_fn_1, pt_fn_2) THEN
	linha2r := ST_RemovePoint(linha2, npt2 - 1);
	inicial := npt2 - 1;
	inverte := TRUE;
      ELSE
	inicial := 0;
    END CASE;
    IF inicial = 0 THEN
      RETURN NULL;
    ELSE
      RETURN 
      ST_MakeLine(u.geom_pt) FROM
       (SELECT pl.geom_pt 
       FROM (SELECT d2.ordem, d2.geom_pt FROM desfaz_linha(linha2r, 0, FALSE) As d2
             UNION
             SELECT d1.ordem, d1.geom_pt FROM desfaz_linha(linha1, inicial, inverte) AS d1) AS pl 
       ORDER BY pl.ordem) AS u;
    END IF;
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;