--
--Cria Tipo bacmont
--
CREATE TYPE bacmont AS
   (codbac character varying,
    bac geometry);
--
--Cria Tipo caract_valor
--
CREATE TYPE caract_valor AS
   (car integer,
    val double precision);
--
--Cria Tipo limjus
--
CREATE TYPE limjus AS
   (crpagua text,
    cdbacmont bigint);
--
--Cria Tipo limmont
--
CREATE TYPE limmont AS
   (cdbacmont bigint,
    cdbacjus bigint);
--
--Cria Tipo rioprinc
--
CREATE TYPE rioprinc AS
   (id_no integer,
    id_tr integer,
    area_mont_tr double precision,
    id_tr_afl integer,
    area_mont_tr_afl double precision);
--
--Cria Tipo rioprinc_cm
--
CREATE TYPE rioprinc_cm AS
   (id_no integer,
    id_tr integer,
    compr_mont_tr double precision,
    id_tr_afl integer,
    compr_mont_tr_afl double precision);
--
--Cria Função acumula_compr_foz(id_trecho integer, compr double precision)
--
CREATE OR REPLACE FUNCTION acumula_compr_foz(id_trecho integer, compr double precision)
  RETURNS integer AS
$BODY$
DECLARE
  node integer;
  comptr double precision;
  idtrconect integer;
  resultado integer;
BEGIN
  SELECT h.no_de, h.compr INTO STRICT node, comptr FROM hidrografia AS h WHERE h.gid = id_trecho;
  INSERT INTO compr_foz VALUES (id_trecho, compr);
  FOR idtrconect IN
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
    LOOP
      resultado = acumula_compr_foz(idtrconect, compr + comptr);
    END LOOP;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função acumula_mapa(id_trecho integer)
--
CREATE OR REPLACE FUNCTION acumula_mapa(id_trecho integer)
  RETURNS SETOF caract_valor AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  i integer;
  c integer;
  v double precision;
  car_val caract_valor;
  valacum double precision[];
BEGIN
  SELECT h.no_de, h.no_para INTO STRICT node, nopara FROM hidrografia AS h WHERE h.gid = id_trecho;
  FOR i IN 1..100 LOOP valacum[i] := 0.; END LOOP;
  FOR idtrconect IN
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
    LOOP
      FOR c, v IN SELECT a.car, a.val FROM acumula_mapa(idtrconect) AS a
        LOOP
          valacum[c] := valacum[c] + v;
        END LOOP;
    END LOOP;
  FOR c, v IN SELECT car, valor FROM mapa_trecho WHERE gid_tr = id_trecho
    LOOP
      valacum[c] := valacum[c] + v;
    END LOOP;
  FOR i IN 1..100
    LOOP
      IF valacum[i] <> 0. THEN
        car_val.car := i; car_val.val := valacum[i];
        RETURN NEXT car_val;
        INSERT INTO mapa_acum_trecho (gid_tr, car, valacum)
        SELECT id_trecho, i, valacum[i];
      END IF; 
    END LOOP;
  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função atribui_direcao_confluencia(id_trecho integer)
--
CREATE OR REPLACE FUNCTION atribui_direcao_confluencia(id_trecho integer)
  RETURNS integer AS
$BODY$
DECLARE
  node integer;
  geomjus geometry;
  geommont geometry;
  geomafl geometry;
  tr record;
  idmont integer;
  idafl integer;
  numtrechos integer;
  res integer;
BEGIN
  SELECT no_de, geom_uni INTO STRICT node, geomjus FROM hidrografia WHERE gid = id_trecho;
  numtrechos = 0;
  FOR tr IN SELECT gid, geom_uni, compr_mont FROM hidrografia WHERE no_para = node ORDER BY compr_mont DESC
    LOOP
      IF numtrechos = 0 THEN
	idmont := tr.gid;
	geommont := tr.geom_uni;
	res := atribui_direcao_confluencia(idmont);
      ELSE
        idafl := tr.gid;
        geomafl := tr.geom_uni;
	res := atribui_direcao_confluencia(idafl);
      END IF;
      numtrechos := numtrechos + 1;
    END LOOP;
    IF numtrechos = 2 THEN
      UPDATE hidrografia SET dir_confl = direcao_confluencia(geomjus, geommont, geomafl) WHERE gid = idafl;
    END IF;
    RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função bacia_montante(codbac character varying)
--
CREATE OR REPLACE FUNCTION bacia_montante(codbac character varying)
  RETURNS SETOF bacmont AS
$BODY$
BEGIN
    RETURN QUERY SELECT codbac, ST_Union(geomproj) AS bac
    FROM area_contrib_eq AS a INNER JOIN limmontante(codbac) AS l
    ON a.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função codifica_interbacia(codigo character varying, id_trecho integer, id_no_limite integer)
--
CREATE OR REPLACE FUNCTION codifica_interbacia(codigo character varying, id_trecho integer, id_no_limite integer)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrpsb record;
  numsb integer;
  idtrsb integer;
BEGIN
  -- numera toda a interbacia com codigo
  resultado := numera_interbacia(codigo, id_trecho, id_no_limite);
  numsb := 1;
  idtrsb := id_trecho;
  FOR regrpsb IN
    SELECT * FROM
    (SELECT r.id_no, r.id_tr, r.area_mont_tr, r.id_tr_afl, r.area_mont_tr_afl FROM rio_principal(codigo, id_trecho, FALSE, id_no_limite) AS r
    ORDER BY r.area_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.area_mont_tr DESC
  LOOP
    -- codifica a interbacia antes da subbacia:
    resultado := codifica_interbacia(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante
  resultado := codifica_interbacia(codigo || numsb, idtrsb, id_no_limite);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função codifica_interbacia_cm(codigo character varying, id_trecho integer, id_no_limite integer)
--
CREATE OR REPLACE FUNCTION codifica_interbacia_cm(codigo character varying, id_trecho integer, id_no_limite integer)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrpsb record;
  numsb integer;
  idtrsb integer;
BEGIN
  -- numera toda a interbacia com codigo
  resultado := numera_interbacia_cm(codigo, id_trecho, id_no_limite);
  numsb := 1;
  idtrsb := id_trecho;
  FOR regrpsb IN
    SELECT * FROM
    (SELECT r.id_no, r.id_tr, r.compr_mont_tr, r.id_tr_afl, r.compr_mont_tr_afl FROM rio_principal_cm(codigo, id_trecho, FALSE, id_no_limite) AS r
    ORDER BY r.compr_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.compr_mont_tr DESC
  LOOP
    -- codifica a interbacia antes da subbacia:
    resultado := codifica_interbacia_cm(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter_cm(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante
  resultado := codifica_interbacia_cm(codigo || numsb, idtrsb, id_no_limite);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função codifica_pfafstetter(codigo character varying, id_trecho integer, bacia_principal boolean)
--
CREATE OR REPLACE FUNCTION codifica_pfafstetter(codigo character varying, id_trecho integer, bacia_principal boolean)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrpsb record;
  numsb integer;
  idtrsb integer;
  idnoterm integer;
BEGIN
  -- numera cobacia em toda a bacia com codigo
  resultado := numera_bacia(codigo, id_trecho);
  numsb := 1;
  idtrsb := id_trecho;
  -- determina as confluências das bacias pares e codifica a interbacia a jusante e a subbacia
  FOR regrpsb IN
    SELECT * FROM
    (SELECT r.id_no, r.id_tr, r.area_mont_tr, r.id_tr_afl, r.area_mont_tr_afl FROM rio_principal(codigo, id_trecho, bacia_principal, NULL) AS r
    ORDER BY r.area_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.area_mont_tr DESC
  LOOP
    -- codifica as interbacia a jusante da subbacia:
    resultado := codifica_interbacia(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante - como uma bacia principal (usa codifica_pfafstetter) mas não é bacia principal (bacia_principal = FALSE)
  resultado := codifica_pfafstetter(codigo || numsb, idtrsb, FALSE);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função codifica_pfafstetter_cm(codigo character varying, id_trecho integer, bacia_principal boolean)
--
CREATE OR REPLACE FUNCTION codifica_pfafstetter_cm(codigo character varying, id_trecho integer, bacia_principal boolean)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrpsb record;
  numsb integer;
  idtrsb integer;
  idnoterm integer;
BEGIN
  -- numera cobacia em toda a bacia com codigo
  resultado := numera_bacia(codigo, id_trecho);
  numsb := 1;
  idtrsb := id_trecho;
  -- determina as confluências das bacias pares e codifica a interbacia a jusante e a subbacia
  FOR regrpsb IN
    SELECT * FROM
    (SELECT r.id_no, r.id_tr, r.compr_mont_tr, r.id_tr_afl, r.compr_mont_tr_afl FROM rio_principal_cm(codigo, id_trecho, bacia_principal, NULL) AS r
    ORDER BY r.compr_mont_tr_afl DESC LIMIT 4) AS bp
    ORDER BY bp.compr_mont_tr DESC
  LOOP
    -- codifica as interbacia a jusante da subbacia:
    resultado := codifica_interbacia_cm(codigo || numsb, idtrsb, regrpsb.id_no);
    idtrsb := regrpsb.id_tr;
    -- codifica a subbacia
    numsb := numsb + 1;
    resultado := codifica_pfafstetter_cm(codigo || numsb, regrpsb.id_tr_afl, TRUE);
    numsb := numsb + 1;
  END LOOP;
  -- se não houve afluente, retorna
  IF numsb = 1 THEN RETURN 0; END IF;
  -- codifica a interbacia de montante - como uma bacia principal (usa codifica_pfafstetter) mas não é bacia principal (bacia_principal = FALSE)
  resultado := codifica_pfafstetter_cm(codigo || numsb, idtrsb, FALSE);
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função cria_arvore(id_no integer, id_trecho integer)
--
CREATE OR REPLACE FUNCTION cria_arvore(id_no integer, id_trecho integer)
  RETURNS double precision AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  nooutro integer;
  idtrconect integer;
  comprtr double precision;
  compracum double precision;
  comprmaior double precision;
BEGIN
  SELECT h.no_de, h.no_para, h.compr INTO STRICT node, nopara, comprtr FROM hidrografia AS h WHERE h.gid = id_trecho;
  IF node = id_no THEN nooutro = nopara; ELSE nooutro = node; END IF;
  comprmaior := 0.;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_de = nooutro AND h.gid <> id_trecho
	UNION
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = nooutro AND h.gid <> id_trecho
  LOOP
    compracum := cria_arvore(nooutro, idtrconect);
    IF compracum > comprmaior THEN comprmaior := compracum; END IF;
  END LOOP;
  INSERT INTO arvore_comprimentos (gid, no_de, no_para, compr, compracum)
  SELECT id_trecho, node, nopara, comprtr, comprtr + comprmaior;
  RETURN comprtr + comprmaior;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função cria_arvore_ar(id_trecho integer)
--
CREATE OR REPLACE FUNCTION cria_arvore_ar(id_trecho integer)
  RETURNS double precision AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  areatr double precision;
  aracum double precision;
BEGIN
  SELECT h.no_de, h.no_para, h.area INTO STRICT node, nopara, areatr FROM hidrografia AS h WHERE h.gid = id_trecho;
  aracum := 0.;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
  LOOP
    aracum := aracum + cria_arvore_ar(idtrconect);
  END LOOP;
  aracum := aracum + areatr;
  INSERT INTO arvore_areas (gid, no_de, no_para, area, areaacum)
  SELECT id_trecho, node, nopara, areatr, aracum;
  RETURN aracum;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função cria_arvore_cm(id_trecho integer)
--
CREATE OR REPLACE FUNCTION cria_arvore_cm(id_trecho integer)
  RETURNS double precision AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  comprtr double precision;
  compracum double precision;
  comprmaior double precision;
BEGIN
  SELECT h.no_de, h.no_para, h.compr INTO STRICT node, nopara, comprtr FROM hidrografia AS h WHERE h.gid = id_trecho;
  comprmaior := 0.;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
  LOOP
    compracum := cria_arvore_cm(idtrconect);
    IF compracum > comprmaior THEN comprmaior := compracum; END IF;
  END LOOP;
  INSERT INTO arvore_comprimentos (gid, no_de, no_para, compr, compracum)
  SELECT id_trecho, node, nopara, comprtr, comprtr + comprmaior;
  RETURN comprtr + comprmaior;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função desfaz_linha(IN geom_linha geometry, IN inicial_ordem integer, IN inverte boolean)
--
CREATE OR REPLACE FUNCTION desfaz_linha(IN geom_linha geometry, IN inicial_ordem integer, IN inverte boolean)
  RETURNS TABLE(ordem integer, geom_pt geometry) AS
$BODY$

DECLARE
num_pontos integer :=  ST_NumPoints(geom_linha);

BEGIN
  IF inverte THEN
    RETURN QUERY
      SELECT inicial_ordem + num_pontos + 1 - n AS ordem, ST_PointN(geom_linha, n) AS geom_pt
      FROM generate_series(1,10000) AS n
      WHERE n <= num_pontos;
  ELSE
    RETURN QUERY
      SELECT inicial_ordem + n AS ordem, ST_PointN(geom_linha, n) AS geom_pt
      FROM generate_series(1,10000) AS n
      WHERE n <= num_pontos;
  END IF;
END;

$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100
  ROWS 1000;
--
--Cria Função direcao_confluencia(geomjus geometry, geommont geometry, geomafl geometry)
--
CREATE OR REPLACE FUNCTION direcao_confluencia(geomjus geometry, geommont geometry, geomafl geometry)
  RETURNS text AS
$BODY$
DECLARE
  xconfl double precision;
  yconfl double precision;
  xjus double precision;
  yjus double precision;
  xmont double precision;
  ymont double precision;
  xafl double precision;
  yafl double precision;
  angjus double precision;
  angmont double precision;
  angafl double precision;
  angrelmont double precision;
  angrelafl double precision;
BEGIN
  -- busca as coordenadas dos pontos característicos (confluência, jusante, montante e afluente)
  xconfl := ST_X(ST_StartPoint(geomjus));
  yconfl := ST_Y(ST_StartPoint(geomjus));
  xjus := ST_X(ST_PointN(geomjus,2));
  yjus := ST_Y(ST_PointN(geomjus,2));
  xmont := ST_X(ST_PointN(geommont,ST_NumPoints(geommont)-1));
  ymont := ST_Y(ST_PointN(geommont,ST_NumPoints(geommont)-1));
  xafl := ST_X(ST_PointN(geomafl,ST_NumPoints(geomafl)-1));
  yafl := ST_Y(ST_PointN(geomafl,ST_NumPoints(geomafl)-1));
  -- determina os angulos absolutos
  angjus := atan2(yjus - yconfl, xjus - xconfl);
  angmont := atan2(ymont - yconfl, xmont - xconfl);
  angafl := atan2(yafl - yconfl, xafl - xconfl);
  -- determina os ângulos relativos
  angrelmont := angmont - angjus;
  angrelafl := angafl - angjus;
  -- reduz os angulos relativos ao intervalo 0 - 2 * pi
  IF angrelmont < 0 THEN angrelmont := angrelmont + 2. * pi(); END IF;
  IF angrelafl < 0 THEN angrelafl := angrelafl + 2. * pi(); END IF;
  -- se angulo de montante > angulo do afluente, confluência pela esquerda; caso contrário, pela direita
  IF angrelmont > angrelafl THEN RETURN 'esq'; ELSE RETURN 'dir'; END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função gera_tabela_topologica(tipo character varying, cotrecho integer, cobacia character varying, dist double precision)
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
        IF tipo = 'area_mont' THEN
          string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text || ' AS SELECT * FROM area_contrib AS a INNER JOIN (SELECT tr_md(''' || cobacia
            || ''', ' || replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ')) AS tm ON a.cotrecho = tm.tr_md';
         ELSE
          string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text || ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT tr_jd(''' || cobacia
            || ''', ' || replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ')) AS tj ON a.cotrecho = tj.tr_jd';
        END IF;
        EXECUTE string_sql;
  END;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função limjusante(codbac character varying)
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
--Cria Função limjusantei(codbac character varying)
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
--Cria Função limmontante(codbac character varying)
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
        -- e o limite superior com o número correspondente ao código com o primeiro algarismo par acrescido de 1
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
--Cria Função numera_bacia(codigo character varying, id_trecho integer)
--
CREATE OR REPLACE FUNCTION numera_bacia(codigo character varying, id_trecho integer)
  RETURNS integer AS
$BODY$
DECLARE
  node integer;
  nopara integer;
  idtrconect integer;
  resultado integer;
BEGIN
  SELECT h.no_de, h.no_para INTO STRICT node, nopara FROM hidrografia AS h WHERE h.gid = id_trecho;
  FOR idtrconect IN 
    SELECT h.gid FROM hidrografia AS h WHERE h.no_para = node
  LOOP
    resultado := numera_bacia(codigo, idtrconect);
  END LOOP;
  UPDATE hidrografia SET cobacia = codigo
  WHERE gid = id_trecho;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função numera_interbacia(codigo character varying, id_trecho integer, id_no_limite integer)
--
CREATE OR REPLACE FUNCTION numera_interbacia(codigo character varying, id_trecho integer, id_no_limite integer)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrp record;
BEGIN
  -- numera o primeiro trecho
  UPDATE hidrografia SET cobacia = codigo WHERE gid = id_trecho;
  FOR regrp IN 
    SELECT r.id_no, r.id_tr, r.area_mont_tr, r.id_tr_afl, r.area_mont_tr_afl FROM rio_principal(codigo, id_trecho, FALSE, id_no_limite) AS r
    ORDER BY r.area_mont_tr_afl DESC
  LOOP
    -- numera o trecho montante:
    UPDATE hidrografia SET cobacia = codigo WHERE gid = regrp.id_tr;
    -- numera a bacia afluente
    resultado := numera_bacia(codigo, regrp.id_tr_afl);
  END LOOP;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função numera_interbacia_cm(codigo character varying, id_trecho integer, id_no_limite integer)
--
CREATE OR REPLACE FUNCTION numera_interbacia_cm(codigo character varying, id_trecho integer, id_no_limite integer)
  RETURNS integer AS
$BODY$
DECLARE
  resultado integer;
  regrp record;
BEGIN
  -- numera o primeiro trecho
  UPDATE hidrografia SET cobacia = codigo WHERE gid = id_trecho;
  FOR regrp IN 
    SELECT r.id_no, r.id_tr, r.compr_mont_tr, r.id_tr_afl, r.compr_mont_tr_afl FROM rio_principal_cm(codigo, id_trecho, FALSE, id_no_limite) AS r
    ORDER BY r.compr_mont_tr_afl DESC
  LOOP
    -- numera o trecho montante:
    UPDATE hidrografia SET cobacia = codigo WHERE gid = regrp.id_tr;
    -- numera a bacia afluente
    resultado := numera_bacia(codigo, regrp.id_tr_afl);
  END LOOP;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função orienta_hidrografia(id_no integer, id_trecho integer)
--
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
  IF nooutro = nopara THEN geomproj_corr := ST_Reverse(geomproj_corr); END IF;
  INSERT INTO hidrografia_reorientada SELECT id_trecho, geomproj_corr;
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--
--Cria Função pontos_linha(IN idlinha integer)
--
CREATE OR REPLACE FUNCTION pontos_linha(IN idlinha integer)
  RETURNS TABLE(np integer, geomproj geometry) AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT n AS np, ST_PointN(h.geomproj_uni, n) AS geomproj
    FROM hidrografia AS h
    CROSS JOIN generate_series(1,10000) AS n
    WHERE n <= ST_NPoints(h.geomproj_uni)
    AND h.gid = idlinha
    ORDER BY n;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função rio_principal(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer)
--
CREATE OR REPLACE FUNCTION rio_principal(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer)
  RETURNS SETOF rioprinc AS
$BODY$
DECLARE
  node integer;
  nodetr integer;
  tr record;
  tr_rp rioprinc;
  idtr integer;
  idafl integer;
  areamonttr double precision;
  areamontafl double precision;
  numtrechos integer;
BEGIN
  IF bacia_principal THEN UPDATE hidrografia SET cocursodag = codigo WHERE gid = id_trecho; END IF;
  SELECT no_de INTO STRICT node FROM hidrografia WHERE gid = id_trecho;
  LOOP
    IF NOT bacia_principal AND node = id_no_limite THEN RETURN; END IF;
    numtrechos = 0;
    FOR tr IN SELECT * FROM hidrografia WHERE no_para = node ORDER BY area_mont DESC
    LOOP
      IF numtrechos = 0 THEN
	idtr := tr.gid;
	areamonttr := tr.area_mont;
	nodetr := tr.no_de;
      ELSE
	idafl := tr.gid;
	areamontafl := tr.area_mont;
      END IF;
      numtrechos := numtrechos + 1;
    END LOOP;
    IF numtrechos = 0 THEN RETURN; END IF;
    tr_rp.id_no := node;
    tr_rp.id_tr := idtr;
    tr_rp.area_mont_tr := areamonttr;
    tr_rp.id_tr_afl := idafl;
    tr_rp.area_mont_tr_afl := areamontafl;
    node := nodetr;
    RETURN NEXT tr_rp;
    IF bacia_principal THEN UPDATE hidrografia SET cocursodag = codigo WHERE gid = idtr; END IF;
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função rio_principal_cm(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer)
--
CREATE OR REPLACE FUNCTION rio_principal_cm(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer)
  RETURNS SETOF rioprinc_cm AS
$BODY$
DECLARE
  node integer;
  nodetr integer;
  tr record;
  tr_rp rioprinc_cm;
  idtr integer;
  idafl integer;
  comprmonttr double precision;
  comprmontafl double precision;
  numtrechos integer;
BEGIN
  IF bacia_principal THEN UPDATE hidrografia SET cocursodag = codigo WHERE gid = id_trecho; END IF;
  SELECT no_de INTO STRICT node FROM hidrografia WHERE gid = id_trecho;
  LOOP
    IF NOT bacia_principal AND node = id_no_limite THEN RETURN; END IF;
    numtrechos = 0;
    FOR tr IN SELECT * FROM hidrografia WHERE no_para = node ORDER BY compr_mont DESC
    LOOP
      IF numtrechos = 0 THEN
	idtr := tr.gid;
	comprmonttr := tr.compr_mont;
	nodetr := tr.no_de;
      ELSE
	idafl := tr.gid;
	comprmontafl := tr.compr_mont;
      END IF;
      numtrechos := numtrechos + 1;
    END LOOP;
    IF numtrechos = 0 THEN RETURN; END IF;
    tr_rp.id_no := node;
    tr_rp.id_tr := idtr;
    tr_rp.compr_mont_tr := comprmonttr;
    tr_rp.id_tr_afl := idafl;
    tr_rp.compr_mont_tr_afl := comprmontafl;
    node := nodetr;
    RETURN NEXT tr_rp;
    IF bacia_principal THEN UPDATE hidrografia SET cocursodag = codigo WHERE gid = idtr; END IF;
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função tr_j(codbac character varying)
--
CREATE OR REPLACE FUNCTION tr_j(codbac character varying)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limjusante(codbac) AS l
    ON (h.cocursodag = l.crpagua AND h.cobacianum < l.cdbacmont);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função tr_jd(codbac character varying, dist double precision)
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
--Cria Função tr_m(codbac character varying)
--
CREATE OR REPLACE FUNCTION tr_m(codbac character varying)
  RETURNS SETOF integer AS
$BODY$
BEGIN
    RETURN QUERY SELECT
    h.cotrecho
    FROM hidrografia AS h
    INNER JOIN limmontante(codbac) AS l
    ON h.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função tr_md(codbac character varying, dist double precision)
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
--
--Cria Função trechos_jusante(IN codbac character varying)
--
CREATE OR REPLACE FUNCTION trechos_jusante(IN codbac character varying)
  RETURNS TABLE(gid integer, nome_dre character varying, compr double precision, compr_mont double precision, cocursodag character varying, cobacia character varying, cobacianum bigint, no_de integer, no_para integer, geom_uni geometry, geomproj_uni geometry) AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT
    h.gid,
    h.nome_dre,
    h.compr,
    h.compr_mont,
    h.cocursodag,
    h.cobacia,
    h.cobacianum,
    h.no_de,
    h.no_para,
    h.geom_uni,
    h.geomproj_uni
    FROM hidrografia AS h
    INNER JOIN limjusante(codbac) AS l
    ON (h.cocursodag = l.crpagua AND h.cobacianum < l.cdbacmont);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função trechos_montante(IN codbac character varying)
--
CREATE OR REPLACE FUNCTION trechos_montante(IN codbac character varying)
  RETURNS TABLE(gid integer, nome_dre character varying, compr double precision, compr_mont double precision, cocursodag character varying, cobacia character varying, cobacianum bigint, no_de integer, no_para integer, geom_uni geometry, geomproj_uni geometry) AS
$BODY$
BEGIN
    RETURN QUERY SELECT
    h.gid,
    h.nome_dre,
    h.compr,
    h.compr_mont,
    h.cocursodag,
    h.cobacia,
    h.cobacianum,
    h.no_de,
    h.no_para,
    h.geom_uni,
    h.geomproj_uni
    FROM hidrografia AS h
    INNER JOIN limmontante(codbac) AS l
    ON h.cobacianum BETWEEN l.cdbacjus AND l.cdbacmont;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
--
--Cria Função une_linhas(linha1 geometry, linha2 geometry)
--
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
