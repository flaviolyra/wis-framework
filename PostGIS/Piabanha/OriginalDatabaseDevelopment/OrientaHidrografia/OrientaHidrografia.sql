CREATE OR REPLACE FUNCTION orienta_hidrografia(id_no integer, id_trecho integer)
  RETURNS integer AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  nooutro integer;
  idtrconect integer;
  retorno integer;
  geomproj_corr geometry(Linestring, 32723);
BEGIN
  SELECT h.no_de, h.no_para, h.geomproj_uni INTO STRICT node, nopara, geomproj_corr FROM hidrografia AS h WHERE h.gid = id_trecho;
  IF node = id_no THEN nooutro = nopara; ELSE nooutro = node; END IF;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_de = nooutro AND h.gid <> id_trecho
	UNION
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = nooutro AND h.gid <> id_trecho
  LOOP
    retorno := orienta_hidrografia(nooutro, idtrconect);
  END LOOP;
  IF nooutro = nopara THEN geomproj_corr := ST_Reverse(geomproj_corr);
  INSERT INTO hidrografia_reorientada SELECT id_trecho, geomproj_corr;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
