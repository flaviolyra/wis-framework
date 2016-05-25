UPDATE nos_quatro_conexoes SET id_tr_jusante = tj.gid
FROM
(SELECT no_term, gid, de_para
FROM nos_trechos_4_conexoes
WHERE ordem_afl = 2) AS tj
WHERE nos_quatro_conexoes.id_no = tj.no_term;
UPDATE nos_quatro_conexoes SET no_lig_tr_jusante = tj.de_para
FROM
(SELECT no_term, gid, de_para
FROM nos_trechos_4_conexoes
WHERE ordem_afl = 2) AS tj
WHERE nos_quatro_conexoes.id_no = tj.no_term;
