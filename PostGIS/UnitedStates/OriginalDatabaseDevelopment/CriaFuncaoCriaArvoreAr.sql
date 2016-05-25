CREATE OR REPLACE FUNCTION cria_arvore_ar(comid_foz integer)
  RETURNS double precision AS
$BODY$
DECLARE
  comid_tr integer;
  frm_node integer;
  to_node integer;
  div integer;
  areatr double precision;
  aracum double precision;
BEGIN
  SELECT fromnode, tonode, divergence, areasqkm INTO STRICT frm_node, to_node, div, areatr FROM hidrografia WHERE comid = comid_foz;
  aracum := 0.;
  IF div < 2 THEN
    FOR comid_tr IN 
      SELECT comid FROM hidrografia WHERE tonode = frm_node
    LOOP
      aracum := aracum + cria_arvore_ar(comid_tr);
    END LOOP;
  END IF;
  aracum := aracum + areatr;
  INSERT INTO arvore_areas (comid, fromnode, tonode, areasqkm, cumareasqkm)
  SELECT comid_foz, frm_node, to_node, areatr, aracum;
  RETURN aracum;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
