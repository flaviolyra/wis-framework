INSERT INTO nos_quatro_conexoes (id_no, id_tr_montante, no_lig_tr_montante)
SELECT no_term, gid, de_para
FROM nos_trechos_4_conexoes
WHERE ordem_afl = 1
ORDER BY no_term;