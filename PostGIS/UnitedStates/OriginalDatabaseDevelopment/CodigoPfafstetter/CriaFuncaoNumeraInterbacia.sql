CREATE OR REPLACE FUNCTION numera_interbacia(codigo character varying, comid_tr integer, idno_limite integer, afluencia_terminal boolean, afl_ident integer[])
RETURNS integer AS
$BODY$
DECLARE
  frm_node integer;
  frm_node_mont integer;
  div integer;
  idtr_mont integer;
  idtr_conect integer;
  resultado integer;
  numconfl integer;
BEGIN
  idtr_mont := comid_tr;
  <<CODIFICA_INTERBACIA>>
  LOOP
    --
    -- preenche com cobacia = codigo enquanto os trechos se seguem sem confluências
    --
    -- se for interbacia sem trecho de rio principal, pula o loop codifica interbacia e codifica afluentes terminais
    IF idtr_mont IS NULL THEN
      EXIT CODIFICA_INTERBACIA;
    END IF;
    <<SEGUE_RIO>>
    LOOP
      -- põe em frm_node e em div o nó de e o divergence do trecho
      SELECT fromnode, divergence INTO STRICT frm_node, div FROM hidrografia WHERE comid = idtr_mont;
      -- faz para o trecho cobacia = codigo
      UPDATE hidrografia SET cobacia = codigo WHERE comid = idtr_mont;
      -- se div for 2, é um trecho terminal da interbacia - sai da rotina
      IF div = 2 THEN
        RETURN 0;
      END IF;
      -- se o nó de for o nó terminal, sai do loop codifica_interbacia e codifica eventuais afluências terminais
      IF frm_node = idno_limite THEN
        EXIT CODIFICA_INTERBACIA;
      END IF;
      -- verifica quantos trechos se ligam ao trecho codificado
      BEGIN
        SELECT comid, fromnode, divergence INTO STRICT idtr_mont, frm_node_mont, div FROM hidrografia WHERE tonode = frm_node;
        EXCEPTION
          -- se nenhum se liga, sai da rotina
          WHEN NO_DATA_FOUND THEN RETURN 0;
          -- se mais de um se liga, é um nó de afluência - codifica cada uma delas (que não estejam já codificadas)
          WHEN TOO_MANY_ROWS THEN EXIT SEGUE_RIO;
      END;
    END LOOP SEGUE_RIO;
    --
    -- codifica todos os afluentes e faz com que idtr_mont seja o trecho de montante (confluência com maior área a montante)
    --
    numconfl := 0;
    FOR idtr_conect IN 
      SELECT comid FROM hidrografia WHERE tonode = frm_node ORDER BY cumareasqkm DESC
    LOOP
      IF numconfl = 0 THEN
        idtr_mont := idtr_conect;
      ELSE
        resultado := numera_bacia(codigo, idtr_conect);
      END IF;
      numconfl := numconfl + 1;
    END LOOP;
  END LOOP CODIFICA_INTERBACIA;
  --
  -- se for o nó terminal com afluência terminal, numera cada bacia dos afluentes que não estiverem na lista de afluentes já identificados
  --
  IF afluencia_terminal THEN
    numconfl := 0;
    FOR idtr_conect IN 
      SELECT comid FROM hidrografia WHERE tonode = idno_limite ORDER BY cumareasqkm DESC
    LOOP
      IF numconfl > 0 AND idtr_conect NOT IN (SELECT unnest(afl_ident)) THEN
        resultado := numera_bacia(codigo, idtr_conect);
      END IF;
      numconfl := numconfl + 1;
    END LOOP;
  END IF;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
