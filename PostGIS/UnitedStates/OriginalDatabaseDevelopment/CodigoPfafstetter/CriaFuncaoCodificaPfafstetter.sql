CREATE OR REPLACE FUNCTION codifica_pfafstetter(codigo character varying, id_trecho integer, bacia_principal boolean)
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
  trechos_afl integer[];
  numsb integer;
  idtr_ini_interbac integer;
  idno_cnf integer;
  idno_cnf_ant integer;
  idno_term integer;
  afl_cod integer[];
  num_afl integer;
  num_afl_cod integer;
BEGIN
  --
  -- numera cobacia em toda a bacia com codigo
  --
  resultado := numera_bacia(codigo, id_trecho);
  --
  -- determina as confluências das bacias pares e armazena no array afluentes
  --
  afluentes := '{}';
  FOR afrp IN
    SELECT * FROM
    (SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM rio_principal(codigo, id_trecho, bacia_principal, NULL, FALSE)
    ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY area_mont_tr DESC
  LOOP
    afluentes := array_append(afluentes, afrp);
  END LOOP;
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
    -- codifica a interbacia a jusante da confluência, se o nó for diferente do anterior
    --
    numsb := numsb + 1;
    IF idno_cnf_ant <> idno_cnf THEN
      -- codifica a interbacia com trecho iniciado por idtr_ini_interbac, com afluência terminal, se o numero de afluentes for maior que o de afluentes
      -- indentificados, ou sem, caso seja igual
      IF num_afl = num_afl_cod THEN
        -- codifica a interbacia sem afluência terminal
        resultado := codifica_interbacia(codigo || numsb, idtr_ini_interbac, idno_cnf, FALSE, NULL);
      ELSE
        -- codifica a interbacia com afluência terminal
        resultado := codifica_interbacia(codigo || numsb, idtr_ini_interbac, idno_cnf, TRUE, afl_cod);
      END IF;
    END IF;
    -- faz o nó anterior igual ao nó atual e o apontador do inicio do trecho da interbacia igual ao trecho de montante da confluência
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
  -- codifica a interbacia de montante como se fosse uma bacia principal (usa codifica_pfafstetter), sinalizando em bacia_principal que não é
  --
  numsb := numsb + 1;
  resultado := codifica_pfafstetter(codigo || numsb, idtr_ini_interbac, FALSE);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
