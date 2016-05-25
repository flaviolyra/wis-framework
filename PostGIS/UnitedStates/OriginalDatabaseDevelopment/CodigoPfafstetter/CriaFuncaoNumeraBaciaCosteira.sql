CREATE OR REPLACE FUNCTION numera_bacia_costeira(codigo character varying, comid_tr integer, idno_limite integer, afluencia_terminal boolean, afl_ident integer[])
RETURNS integer AS
$BODY$
DECLARE
  frm_node integer;
  frm_node_mont integer;
  idtr_mont integer;
  tr_conect record;
  resultado integer;
BEGIN
  idtr_mont := comid_tr;
  <<CODIFICA_BACIA_COSTA>>
  LOOP
    --
    -- preenche com cobacia = codigo enquanto os trechos se seguem sem confluências
    --
    <<SEGUE_COSTA>>
    LOOP
      -- põe em frm_node o nó de do trecho
      SELECT fromnode INTO STRICT frm_node FROM hidrografia WHERE comid = idtr_mont;
      -- faz para o trecho cobacia = codigo
      UPDATE hidrografia SET cobacia = codigo WHERE comid = idtr_mont;
      -- se o nó de for o nó terminal, sai do loop codifica_interbacia e codifica eventuais afluências terminais
      IF frm_node = idno_limite THEN
        EXIT CODIFICA_BACIA_COSTA;
      END IF;
      -- verifica quantos trechos se ligam ao trecho codificado
      BEGIN
        SELECT comid, fromnode INTO STRICT idtr_mont, frm_node_mont FROM hidrografia WHERE tonode = frm_node;
        EXCEPTION
          -- se nenhum se liga, sai da rotina
          WHEN NO_DATA_FOUND THEN RETURN 0;
          -- se mais de um se liga, é um nó de afluência - codifica cada uma delas (que não estejam já codificadas)
          WHEN TOO_MANY_ROWS THEN EXIT SEGUE_COSTA;
      END;
    END LOOP SEGUE_COSTA;
    --
    -- codifica todos os afluentes e faz com que idtr_mont seja o trecho de montante (confluência com maior área a montante)
    --
    FOR tr_conect IN 
      SELECT comid, ftype FROM hidrografia WHERE tonode = frm_node
    LOOP
      IF tr_conect.ftype = 'Coastline' THEN
        idtr_mont := tr_conect.comid;
      ELSE
        resultado := numera_bacia(codigo, tr_conect.comid);
      END IF;
    END LOOP;
  END LOOP CODIFICA_BACIA_COSTA;
  --
  -- se for o nó terminal com afluência terminal, numera cada bacia dos afluentes que não estiverem na lista de afluentes já identificados
  --
  IF afluencia_terminal THEN
    FOR tr_conect IN 
      SELECT comid, ftype FROM hidrografia WHERE tonode = idno_limite
    LOOP
      IF tr_conect.ftype <> 'Coastline' AND tr_conect.comid NOT IN (SELECT unnest(afl_ident)) THEN
        resultado := numera_bacia(codigo, tr_conect.comid);
      END IF;
    END LOOP;
  END IF;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
