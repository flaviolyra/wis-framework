CREATE OR REPLACE FUNCTION codifica_bacia_costeira(codigo character varying, id_trecho integer, id_no_limite integer, afluencia_terminal boolean,
 afl_term_ident integer[])
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  afrp rioprinc;
  afluentes rioprinc[];
  nos_confls no_confl[];
  nc no_confl;
  id_no_lista integer;
  num_no_lista integer;
  numsb integer;
  idtr_ini_interbac integer;
  idno_cnf integer;
  idno_cnf_ant integer;
  idno_term integer;
  num_afl integer;
  afl_cod integer[];
  num_afl_cod integer;
  idtrsb integer;
BEGIN
  --
  -- numera cobacia em toda a interbacia com codigo
  --
  resultado := numera_bacia_costeira(codigo, id_trecho, id_no_limite, afluencia_terminal,  afl_term_ident);
  --
  -- determina as confluências das bacias pares, excluindo as afluências já identificadas (se houver afluencia terminal), e armazena no array afluentes
  --
  afluentes := '{}';
  IF afluencia_terminal THEN
    FOR afrp IN
      SELECT * FROM
      (SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM linha_costa(id_trecho, id_no_limite, afluencia_terminal)
      WHERE id_tr_afl NOT IN (SELECT unnest(afl_term_ident)) ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
      ORDER BY area_mont_tr
    LOOP
      afluentes := array_append(afluentes, afrp);
    END LOOP;
  ELSE
    FOR afrp IN
      SELECT * FROM
      (SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM linha_costa(id_trecho, id_no_limite, afluencia_terminal)
      ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
      ORDER BY area_mont_tr
    LOOP
      afluentes := array_append(afluentes, afrp);
    END LOOP;
  END IF;
  --
  -- cria o arrray nos_confls com os numeros dos nós de afluentes e o array de numeros dos trechos de afluentes correspondentes
  --
  nos_confls := '{}';
  id_no_lista := 0;
  num_no_lista := 0;
  FOREACH afrp IN ARRAY afluentes
  LOOP
    IF afrp.id_no <> id_no_lista THEN
      -- se for um novo nó, acrescenta no array nos_confls, com seu número de afluentes e trecho afluente a codificar, e incrementa o número de nós
      nc.id_no := afrp.id_no;
      nc.afl_codif := '{}';
      nc.num_afl := afrp.nm_afl;
      nc.afl_codif := array_append (nc.afl_codif, afrp.id_tr_afl);
      nos_confls := array_append(nos_confls, nc);
      id_no_lista := afrp.id_no;
      num_no_lista := num_no_lista + 1;
    ELSE
      -- se não for novo (é igual ao último acrescentado), acrescenta em sua lista de trechos afluentes o trecho afluente a codificar atual
      nc := nos_confls[num_no_lista];
      nc.afl_codif := array_append(nc.afl_codif, afrp.id_tr_afl);
      nos_confls[num_no_lista] := nc;
    END IF;
  END LOOP;
  --
  -- afluência terminal - se o ultimo nó da lista for o nó limite, acrescenta à lista dos codificados nesta etapa os identificados anteriormente
  --
  IF afluencia_terminal THEN
    IF nos_confls[num_no_lista].id_no = id_no_limite THEN
      nc := nos_confls[num_no_lista];
      nc.afl_codif := array_cat(nc.afl_codif, afl_term_ident);
      nos_confls[num_no_lista] := nc;
    END IF;
  END IF;
  --
  -- determina as confluências das bacias pares e codifica cada interbacia a jusante e subbacia
  --
  numsb := 0;
  idtr_ini_interbac := id_trecho;
  idno_cnf_ant:= 0;
  num_no_lista := 1;
  FOREACH afrp IN ARRAY afluentes
  LOOP
    -- sincroniza a lista nos_confls com a lista afluentes e determina a partir da lista nos_confls a lista e o numero de afluentes identificados
    -- no contexto presente e o número total de afluencias no nó
    idno_cnf := afrp.id_no;
    IF idno_cnf <> nos_confls[num_no_lista].id_no THEN
      num_no_lista := num_no_lista + 1;
    END IF;
    afl_cod := nos_confls[num_no_lista].afl_codif;
    -- determina o numero de afluentes já identificados
    num_afl_cod := array_length(afl_cod, 1);
    num_afl := nos_confls[num_no_lista].num_afl;
    --
    -- codifica a bacia costeira a jusante da confluência, se o nó for diferente do anterior
    --
    numsb := numsb + 1;
    IF idno_cnf_ant <> idno_cnf THEN
      -- codifica a bacia costeira com trecho iniciado por idtr_ini_interbac, com afluência terminal, se o numero de afluentes for maior que o de afluentes
      -- indentificados, ou sem, caso seja igual
      IF num_afl = num_afl_cod THEN
        -- codifica a bacia costeira sem afluência terminal
        resultado := codifica_bacia_costeira(codigo || numsb, idtr_ini_interbac, idno_cnf, FALSE, NULL);
      ELSE
        -- codifica a interbacia com afluência terminal
        resultado := codifica_bacia_costeira(codigo || numsb, idtr_ini_interbac, idno_cnf, TRUE, afl_cod);
      END IF;
    END IF;
    -- faz o nó anterior igual ao nó atual e o apontador do inicio do trecho da bacia costeira igual ao trecho de montante da confluência
    idno_cnf_ant := idno_cnf;
    idtr_ini_interbac := afrp.id_tr;
    --
    -- codifica a subbacia
    --
    numsb := numsb + 1;
    resultado := codifica_pfafstetter(codigo || numsb, afrp.id_tr_afl, TRUE);
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 0 THEN RETURN 0; END IF;
  --
  -- se o ultimo nó da lista não for o nó limite, codifica a bacia costeira de montante
  --
  numsb := numsb + 1;
  IF nos_confls[num_no_lista].id_no <> id_no_limite THEN
    resultado := codifica_bacia_costeira(codigo || numsb, idtr_ini_interbac, id_no_limite, afluencia_terminal, afl_term_ident);
  END IF;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
