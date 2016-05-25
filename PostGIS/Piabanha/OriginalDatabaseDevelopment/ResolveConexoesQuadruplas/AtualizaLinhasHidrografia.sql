UPDATE hidrografia SET geomproj_uni = nqc.geom_ntr_montante
FROM nos_quatro_conexoes AS nqc
WHERE hidrografia.gid = nqc.id_tr_montante AND nqc.geom_ntr_montante IS NOT NULL;
UPDATE hidrografia SET geomproj_uni = nqc.geom_ntr_afl_1
FROM nos_quatro_conexoes AS nqc
WHERE hidrografia.gid = nqc.id_tr_afl_1 AND nqc.geom_ntr_afl_1 IS NOT NULL;
UPDATE hidrografia SET geomproj_uni = nqc.geom_ntr_afl_2
FROM nos_quatro_conexoes AS nqc
WHERE hidrografia.gid = nqc.id_tr_afl_2 AND nqc.geom_ntr_afl_2 IS NOT NULL;
INSERT INTO hidrografia (geomproj_uni)
SELECT geom_ntr_lig FROM nos_quatro_conexoes WHERE geom_ntr_lig IS NOT NULL;