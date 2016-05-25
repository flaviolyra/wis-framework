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