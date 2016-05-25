--
-- Cria Tipo bacmont
--
CREATE TYPE bacmont AS
   (codbac character varying,
    bac geometry);
--
-- Cria Tipo limjus
--
CREATE TYPE limjus AS
   (crpagua text,
    cdbacmont bigint);
--
-- Cria Tipo limmont
--
CREATE TYPE limmont AS
   (cdbacmont bigint,
    cdbacjus bigint);
--
-- Cria Tipo no_confl
--
CREATE TYPE no_confl AS
   (id_no integer,
    num_afl integer,
    afl_codif integer[]);
--
-- Cria Tipo rioprinc
--
CREATE TYPE rioprinc AS
   (id_no integer,
    nm_afl integer,
    id_tr integer,
    area_mont_tr double precision,
    id_tr_afl integer,
    area_mont_tr_afl double precision);
--
-- Cria Tipo trecho
--
CREATE TYPE trecho AS
   (comid integer,
    frm_node integer,
    to_node integer,
    div integer,
    tipo character varying(24),
    areatr double precision);
--
-- Cria Função codifica_bacia_costeira(codigo character varying, id_trecho integer, id_no_limite integer, afluencia_terminal boolean, afl_term_ident integer[])
--
CREATE OR REPLACE FUNCTION codifica_bacia_costeira(codigo character varying, id_trecho integer, id_no_limite integer, afluencia_terminal boolean, afl_term_ident integer[])
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
--
-- Cria Função codifica_interbacia(codigo character varying, id_trecho integer, id_no_limite integer, afluencia_terminal boolean, afl_term_ident integer[])
--
CREATE OR REPLACE FUNCTION codifica_interbacia(codigo character varying, id_trecho integer, id_no_limite integer, afluencia_terminal boolean, afl_term_ident integer[])
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
  resultado := numera_interbacia(codigo, id_trecho, id_no_limite, afluencia_terminal, afl_term_ident);
  --
  -- determina as confluências das bacias pares, excluindo as afluências já identificadas (se houver afluencia terminal), e armazena no array afluentes
  --
  afluentes := '{}';
  IF afluencia_terminal THEN
    FOR afrp IN
      SELECT * FROM
      (SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM rio_principal(codigo, id_trecho, FALSE, id_no_limite, afluencia_terminal)
      WHERE id_tr_afl NOT IN (SELECT unnest(afl_term_ident)) ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
      ORDER BY area_mont_tr DESC
    LOOP
      afluentes := array_append(afluentes, afrp);
    END LOOP;
  ELSE
    FOR afrp IN
      SELECT * FROM
      (SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM rio_principal(codigo, id_trecho, FALSE, id_no_limite, afluencia_terminal)
      ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
      ORDER BY area_mont_tr DESC
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
  -- se o ultimo nó da lista não for o nó limite, codifica a interbacia de montante
  --
  numsb := numsb + 1;
  IF nos_confls[num_no_lista].id_no <> id_no_limite THEN
    resultado := codifica_interbacia(codigo || numsb, idtr_ini_interbac, id_no_limite, afluencia_terminal, afl_term_ident);
  END IF;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
-- Cria Função codifica_pfafstetter(codigo character varying, id_trecho integer, bacia_principal boolean)
--
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
--
-- Cria Função cria_arvore_ar(comid_foz integer)
--
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
--
-- Cria Função cria_arvore_ar_interbac(comid_ini integer)
--
CREATE OR REPLACE FUNCTION cria_arvore_ar_interbac(comid_ini integer)
  RETURNS integer AS
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
--
-- Cria Função gera_tabela_topologica(tipo character varying, cotrecho integer, cobacia character varying, dist double precision)
--
CREATE OR REPLACE FUNCTION gera_tabela_topologica(tipo character varying, cotrecho integer, cobacia character varying, dist double precision)
  RETURNS integer AS
$BODY$
DECLARE
  nome_schema text;
  nome_tabela text;
  string_sql text;
BEGIN
  BEGIN
    SELECT schema_name INTO STRICT nome_schema FROM information_schema.schemata WHERE schema_name = 'montante_jusante';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CREATE SCHEMA montante_jusante;
  END;
  BEGIN
    SELECT table_name INTO STRICT nome_tabela FROM information_schema.tables WHERE table_schema='montante_jusante' AND table_name = tipo || '_' || cotrecho::text;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CASE tipo
          WHEN 'area_mont' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM area_contrib AS a INNER JOIN (SELECT tr_md(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ') AS tr) AS tm ON a.cotrecho = tm.tr';
          WHEN 'trecho_mont' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT tr_md(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ') AS tr) AS tm ON a.cotrecho = tm.tr';
          WHEN 'curso_princ_jus' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT tr_jd(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ') AS tr) AS tj ON a.cotrecho = tj.tr';
          WHEN 'curso_total_jus' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT unnest(tr_jdt(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ', ''{}'', TRUE)) AS tr) AS tj ON a.cotrecho = tj.tr';
          ELSE
            RETURN 1;
        END CASE;
        EXECUTE string_sql;
  END;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
-- Cria Função limjusante(codbac character varying)
--
CREATE OR REPLACE FUNCTION limjusante(codbac character varying)
  RETURNS SETOF limjus AS
$BODY$

DECLARE
limites limjus;
array_car text[] := string_to_array(codbac,NULL);
comp_array int := array_length(array_car, 1);
lim_mont bigint := rpad(codbac, 15, '0')::bigint;

BEGIN
  IF comp_array > 1 THEN
    LOOP
      IF array_car[comp_array]::int % 2 = 0 THEN
    -- algarismo é par:
        -- acrescenta à matriz o código do rio como string
        -- acrescenta à matriz o limite montante - faz novo limite igual a número correspondente ao código do rio
        limites.crpagua := array_to_string(array_car,'');
        limites.cdbacmont := lim_mont;
       RETURN NEXT limites;
        lim_mont := rpad(array_to_string(array_car,''), 15, '0')::bigint;
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
--
-- Cria Função limjusantei(codbac character varying)
--
CREATE OR REPLACE FUNCTION limjusantei(codbac character varying)
  RETURNS SETOF limjus AS
$BODY$

DECLARE
limites limjus;
array_car text[] := string_to_array(codbac,NULL);
comp_array int := array_length(array_car, 1);
lim_mont bigint := rpad(codbac, 15, '0')::bigint + 1;

BEGIN
  IF comp_array > 1 THEN
    LOOP
      IF array_car[comp_array]::int % 2 = 0 THEN
    -- algarismo é par:
        -- acrescenta à matriz o código do rio como string
        -- acrescenta à matriz o limite montante - faz novo limite igual a número correspondente ao código do rio
        limites.crpagua := array_to_string(array_car,'');
        limites.cdbacmont := lim_mont;
       RETURN NEXT limites;
        lim_mont := rpad(array_to_string(array_car,''), 15, '0')::bigint;
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
--
-- Cria Função limmontante(codbac character varying)
--
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
--
-- Cria Função linha_costa(id_trecho integer, id_no_limite integer, afluencia_terminal boolean)
--
CREATE OR REPLACE FUNCTION linha_costa(id_trecho integer, id_no_limite integer, afluencia_terminal boolean)
  RETURNS SETOF rioprinc AS
$BODY$
DECLARE
  frm_node integer;
  div integer;
  nodetr integer;
  idtrjus integer;
  idtrmon integer;
  compr double precision;
  compracum double precision;
  areamonttr double precision;
  numafl integer;
  trecho record;
  tr_rp rioprinc;
  tipo text;
BEGIN
  --
  -- Acompanha cada conjunto: Conjunto de trechos da linha de costa + Conjunto de afluentes
  --
  idtrjus := id_trecho;
  compracum := 0.;
  <<LINHA_COSTA>>
  LOOP
    --
    -- Acompanha cada um dos trechos que compõem a linha de costa sem afluências
    --
    <<SEGUE_LINHA>>
    LOOP
      -- acompanha os trechos da linha de costa
      SELECT fromnode, lengthkm, ftype INTO STRICT frm_node, compr, tipo FROM hidrografia WHERE comid = idtrjus;
      -- se não for tipo coastline, retorna
      IF tipo <> 'Coastline' THEN
        RETURN;
      END IF;
      -- acumula comprimento a partir do ponto de jusante do trecho inicial
      compracum := compracum + compr;
      -- Sai da rotina se chegar ao nó limite
      IF frm_node = id_no_limite THEN
        -- se houver afluência terminal, acrescenta o conjunto de afluências e sai
        IF afluencia_terminal THEN
          -- coloca em numafl o numero de afluentes (tipos diferentes de coastline)
          SELECT count(comid) INTO numafl FROM hidrografia WHERE tonode = id_no_limite AND ftype <> 'Coastline';
          -- coloca em comid o identificador do trecho de tipo coastline
          SELECT comid INTO idtrmon FROM hidrografia WHERE tonode = id_no_limite AND ftype = 'Coastline';
          -- gera tantos registros rioprinc quantos forem os afluentes
          FOR trecho IN SELECT * FROM hidrografia WHERE tonode = id_no_limite AND ftype <> 'Coastline'
            LOOP
              tr_rp.id_no := id_no_limite;
              tr_rp.nm_afl := numafl;
              tr_rp.id_tr := idtrmon;
              tr_rp.area_mont_tr := compracum;
              tr_rp.id_tr_afl := trecho.comid;
              tr_rp.area_mont_tr_afl := trecho.cumareasqkm;
              RETURN NEXT tr_rp;
            END LOOP;
        END IF;
        RETURN;
      END IF;
      -- não sendo último trecho da costa, pesquisa os trechos que se ligam ao nó de montante (frm_node)
      BEGIN
        SELECT comid INTO STRICT idtrjus FROM hidrografia WHERE tonode = frm_node;
        EXCEPTION
          -- se nenhum se liga, sai da rotina
          WHEN NO_DATA_FOUND THEN RETURN;
          -- se mais de um se liga, é um nó de afluência - passa à análise das afluências
          WHEN TOO_MANY_ROWS THEN EXIT SEGUE_LINHA;
      END;
    END LOOP SEGUE_LINHA;
    --
    -- Pesquisa as afluências e retorna os registros correspondentes
    --
    -- coloca em numafl o numero de afluentes (tipos diferentes de coastline)
    SELECT count(comid) INTO numafl FROM hidrografia WHERE tonode = frm_node AND ftype <> 'Coastline';
    -- coloca em comid o identificador do trecho de tipo coastline
    SELECT comid INTO idtrmon FROM hidrografia WHERE tonode = frm_node AND ftype = 'Coastline';
    FOR trecho IN SELECT * FROM hidrografia WHERE tonode = frm_node AND ftype <> 'Coastline'
      LOOP
        tr_rp.id_no := frm_node;
        tr_rp.nm_afl := numafl;
        tr_rp.id_tr := idtrmon;
        tr_rp.area_mont_tr := compracum;
        tr_rp.id_tr_afl := trecho.comid;
        tr_rp.area_mont_tr_afl := trecho.cumareasqkm;
        RETURN NEXT tr_rp;
      END LOOP;
    -- faz com que o trecho de jusante seja o de montante das afluências e continua seguindo o rio principal
    idtrjus := idtrmon;
  END LOOP LINHA_COSTA;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
-- Cria Função numera_bacia(codigo character varying, comid_tr integer)
--
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
--
-- Cria Função numera_bacia_costeira(codigo character varying, comid_tr integer, idno_limite integer, afluencia_terminal boolean, afl_ident integer[])
--
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
--
-- Cria Função numera_interbacia(codigo character varying, comid_tr integer, idno_limite integer, afluencia_terminal boolean, afl_ident integer[])
--
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
--
-- Cria Função rio_principal(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer, afluencia_terminal boolean)
--
CREATE OR REPLACE FUNCTION rio_principal(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer, afluencia_terminal boolean)
  RETURNS SETOF rioprinc AS
$BODY$
DECLARE
  frm_node integer;
  div integer;
  nodetr integer;
  idtrjus integer;
  idtrmon integer;
  areamonttr double precision;
  indconfl integer;
  numafl integer;
  trecho record;
  tr_rp rioprinc;
BEGIN
  --
  -- Acompanha cada conjunto: Conjunto de trechos do curso principal + Conjunto de afluentes
  --
  idtrjus := id_trecho;
  <<RIO_PRINCIPAL>>
  LOOP
    --
    -- Acompanha cada um dos trechos que compõem o curso principal sem afluências e faz cocursodag = código, se for bacia principal
    --
    <<SEGUE_RIO>>
    LOOP
      -- acompanha os trechos do rio principal
      IF bacia_principal THEN
        UPDATE hidrografia SET cocursodag = codigo WHERE comid = idtrjus;
      END IF;
      SELECT fromnode, divergence INTO STRICT frm_node, div FROM hidrografia WHERE comid = idtrjus;
      -- se encontrar uma divergência secundária, é cabeceira - retorna
      IF div = 2 THEN
        RETURN;
      END IF;
      -- se for pesquisa de interbacia (bacia_principal = false), verifica se é o nó terminal
      IF NOT bacia_principal AND frm_node = id_no_limite THEN
        -- Sai da rotina se, não sendo bacia principal, chega ao nó limite
        IF afluencia_terminal THEN
          -- se houver afluência terminal, acrescenta ao conjunto de afluências e sai
          indconfl := 0;
          SELECT count(comid) - 1 INTO numafl FROM hidrografia WHERE tonode = id_no_limite;
          FOR trecho IN SELECT * FROM hidrografia WHERE tonode = id_no_limite ORDER BY cumareasqkm DESC
            LOOP
              IF indconfl = 0 THEN
                -- Trecho de maior área é o de montante no rio principal
                idtrmon := trecho.comid;
                areamonttr := trecho.cumareasqkm;
                nodetr := trecho.fromnode;
              ELSE
                -- Outros são afluências - acrescenta ao conjunto de saída da função
                tr_rp.id_no := id_no_limite;
                tr_rp.nm_afl := numafl;
                tr_rp.id_tr := idtrmon;
                tr_rp.area_mont_tr := areamonttr;
                tr_rp.id_tr_afl := trecho.comid;
                tr_rp.area_mont_tr_afl := trecho.cumareasqkm;
                RETURN NEXT tr_rp;
              END IF;
              indconfl := indconfl + 1;
            END LOOP;
        END IF;
        RETURN;
      END IF;
      -- não sendo último trecho de uma interbacia, pesquisa os trechos que se ligam ao nó de montante (frm_node)
      BEGIN
        SELECT comid INTO STRICT idtrjus FROM hidrografia WHERE tonode = frm_node;
        EXCEPTION
          -- se nenhum se liga, sai da rotina
          WHEN NO_DATA_FOUND THEN RETURN;
          -- se mais de um se liga, é um nó de afluência - passa à análise das afluências
          WHEN TOO_MANY_ROWS THEN EXIT SEGUE_RIO;
      END;
    END LOOP SEGUE_RIO;
    --
    -- Pesquisa as afluências e retorna os registros correspondentes
    --
    indconfl := 0;
    SELECT count(comid) - 1 INTO numafl FROM hidrografia WHERE tonode = frm_node;
    FOR trecho IN SELECT * FROM hidrografia WHERE tonode = frm_node ORDER BY cumareasqkm DESC
      LOOP
        IF indconfl = 0 THEN
          -- Trecho de maior área é o de montante no rio principal
          idtrmon := trecho.comid;
          areamonttr := trecho.cumareasqkm;
          nodetr := trecho.fromnode;
        ELSE
          -- Outros são afluências - acrescenta ao conjunto de saída da função
          tr_rp.id_no := frm_node;
          tr_rp.nm_afl := numafl;
          tr_rp.id_tr := idtrmon;
          tr_rp.area_mont_tr := areamonttr;
          tr_rp.id_tr_afl := trecho.comid;
          tr_rp.area_mont_tr_afl := trecho.cumareasqkm;
          RETURN NEXT tr_rp;
        END IF;
        indconfl := indconfl + 1;
      END LOOP;
    -- faz com que o trecho de jusante seja o de montante das afluências e continua seguindo o rio principal
    idtrjus := idtrmon;
  END LOOP RIO_PRINCIPAL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
-- Cria Função tr_jd(codbac character varying, dist double precision)
--
CREATE OR REPLACE FUNCTION tr_jd(codbac character varying, dist double precision)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limjusantei(codbac) AS l
    ON (h.cocursodag = l.crpagua AND h.cobacianum < l.cdbacmont)
    WHERE nudistbact < dist - 0.001;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
-- Cria Função tr_jdt(codbac character varying, dist double precision, tr_ident_ant integer[], prim_tr boolean)
--
CREATE OR REPLACE FUNCTION tr_jdt(codbac character varying, dist double precision, tr_ident_ant integer[], prim_tr boolean)
  RETURNS integer[] AS
$BODY$
DECLARE
  id_tr integer;
  id_node integer;
  cobacia_tr character varying(30);
  dist_tr double precision;
  cotrecho_tr integer;
  tr_ident integer[];
  tr_ident_ent integer[];
  tr_ident_saida integer[];
  no_ident integer[];
  dist_lim double precision;
BEGIN
  -- se for primeiro trecho faz dist_lim menor do que dist (trecho não será incluído no caminho)
  -- se não, faz dist_lim maior que dist (trecho será incluído)
  IF prim_tr THEN
    dist_lim := dist - 0.001;
  ELSE
    dist_lim := dist + 0.001;
  END IF;
  -- busca os códigos e os no para dos trechos a jusante do trecho indicado,
  -- que não estejam no array tr_ident_ant, e coloca nos arrays tr_ident e no_ident
  tr_ident := '{}';
  no_ident := '{}';
  FOR id_tr, id_node IN SELECT h.cotrecho, h.fromnode FROM hidrografia AS h INNER JOIN limjusantei(codbac) AS l
    ON (h.cocursodag = l.crpagua AND h.cobacianum < l.cdbacmont) WHERE h.nudistbact < dist_lim AND h.cotrecho NOT IN (SELECT unnest(tr_ident_ant))
  LOOP
    tr_ident := array_append(tr_ident, id_tr);
    no_ident := array_append(no_ident, id_node);
  END LOOP;
  -- faz o array de trechos de saida igual aos identificados anteriormente mais os identificados nesta chamada
  tr_ident_saida := array_cat(tr_ident_ant, tr_ident);
  -- busca os nós com divergências e, para cada divergência de cada um deles que não esteja em tr_ident_saida, chama a rotina tr_jdt
  FOR cotrecho_tr, cobacia_tr, dist_tr IN SELECT h.cotrecho, h.cobacia, h.nudistbact FROM hidrografia AS h
    INNER JOIN (SELECT comid FROM divergencias WHERE nodenumber IN (SELECT unnest(no_ident))) AS tr ON h.cotrecho = tr.comid
    WHERE h.cotrecho NOT IN (SELECT unnest(tr_ident_saida))
  LOOP
    -- faz o array de trechos já identificados igual ao tr_ident_saida anterior
    tr_ident_ent := tr_ident_saida;
    -- chama recursivamente a rotina parra calcular novo array tr_ident_saida
    tr_ident_saida := tr_jdt(cobacia_tr, dist_tr, tr_ident_ent, FALSE);
  END LOOP;
  RETURN tr_ident_saida;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
-- Cria Função tr_md(codbac character varying, dist double precision)
--
CREATE OR REPLACE FUNCTION tr_md(codbac character varying, dist double precision)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limmontante(codbac) AS l
    ON h.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont
    WHERE h.nudistbact > dist - 0.001;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
