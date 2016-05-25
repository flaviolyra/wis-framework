CREATE FUNCTION cria_arvore_ar_interbac(comid_ini integer) RETURNS integer AS
$BODY$
DECLARE
  tr_inic trecho;
  tr_intrlg trecho;
  num_intrlg integer;
BEGIN
  SELECT comid, fromnode, tonode, divergence, ftype, areasqkm INTO STRICT tr_inic
  FROM hidrografia WHERE comid = comid_ini;
  IF tr_inic.tipo <> 'Coastline' THEN RETURN 0; END IF;
  INSERT INTO arvore_areas (comid, fromnode, tonode, areasqkm, cumareasqkm)
  SELECT tr_inic.comid, tr_inic.frm_node, tr_inic.to_node, tr_inic.areatr, tr_inic.areatr;
  LOOP
    num_intrlg := 0;
    FOR tr_intrlg IN 
      SELECT h.comid, h.fromnode, h.tonode, h.divergence, h.ftype, h.areasqkm FROM hidrografia AS h WHERE h.tonode = tr_inic.frm_node
    LOOP
      IF tr_intrlg.tipo = 'Coastline' THEN
        INSERT INTO arvore_areas (comid, fromnode, tonode, areasqkm, cumareasqkm)
        SELECT tr_intrlg.comid, tr_intrlg.frm_node, tr_intrlg.to_node, tr_intrlg.areatr, tr_intrlg.areatr;
        tr_inic := tr_intrlg;
        num_intrlg := num_intrlg + 1;
      ELSE
        PERFORM cria_arvore_ar(tr_intrlg.comid);
      END IF;
    END LOOP;
    IF num_intrlg = 0 THEN EXIT; END IF;
  END LOOP;
  RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
