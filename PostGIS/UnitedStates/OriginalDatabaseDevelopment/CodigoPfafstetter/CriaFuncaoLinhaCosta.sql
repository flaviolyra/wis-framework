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
