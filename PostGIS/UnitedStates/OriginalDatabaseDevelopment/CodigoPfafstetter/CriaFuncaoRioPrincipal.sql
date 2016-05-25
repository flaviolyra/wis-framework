CREATE OR REPLACE FUNCTION rio_principal(codigo character varying, id_trecho integer, bacia_principal boolean, id_no_limite integer,
  afluencia_terminal boolean)
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
