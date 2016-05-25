CREATE OR REPLACE FUNCTION numera_bacia(codigo character varying, comid_tr integer)
RETURNS integer AS
$BODY$
DECLARE
  frm_node integer;
  frm_node_mont integer;
  div integer;
  idtr_mont integer;
  idtr_conect integer;
  resultado integer;
BEGIN
  idtr_mont := comid_tr;
  SELECT fromnode, divergence INTO STRICT frm_node, div FROM hidrografia WHERE comid = idtr_mont;
  -- preenche com cobacia = codigo enquanto os trechos se seguem sem confluências
  <<SEGUE_RIO>>
  LOOP
    -- faz para cada trecho cobacia = codigo
    UPDATE hidrografia SET cobacia = codigo WHERE comid = idtr_mont;
    IF div = 2 THEN
      RETURN 0;
    END IF;
    BEGIN
      SELECT comid, fromnode, divergence INTO STRICT idtr_mont, frm_node_mont, div FROM hidrografia WHERE tonode = frm_node;
      EXCEPTION
        -- se nenhum se liga, sai da rotina
        WHEN NO_DATA_FOUND THEN RETURN 0;
        -- se mais de um se liga, é um nó de afluência - codifica cada uma delas
        WHEN TOO_MANY_ROWS THEN EXIT SEGUE_RIO;
    END;
    frm_node := frm_node_mont;
  END LOOP;
  -- numera cada bacia das confluências
  FOR idtr_conect IN 
    SELECT comid FROM hidrografia WHERE tonode = frm_node
  LOOP
      resultado := numera_bacia(codigo, idtr_conect);
  END LOOP;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
