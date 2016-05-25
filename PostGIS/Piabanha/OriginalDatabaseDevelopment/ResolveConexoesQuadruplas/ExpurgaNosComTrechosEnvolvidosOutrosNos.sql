DELETE FROM nos_quatro_conexoes WHERE id_tr_jusante IN (SELECT id_tr_montante FROM nos_quatro_conexoes);
DELETE FROM nos_quatro_conexoes WHERE id_tr_afl_1 IN (SELECT id_tr_montante FROM nos_quatro_conexoes);
DELETE FROM nos_quatro_conexoes WHERE id_tr_afl_2 IN (SELECT id_tr_montante FROM nos_quatro_conexoes);
DELETE FROM nos_quatro_conexoes WHERE id_tr_afl_1 IN (SELECT id_tr_jusante FROM nos_quatro_conexoes);
DELETE FROM nos_quatro_conexoes WHERE id_tr_afl_2 IN (SELECT id_tr_jusante FROM nos_quatro_conexoes);
DELETE FROM nos_quatro_conexoes WHERE id_tr_afl_2 IN (SELECT id_tr_afl_1 FROM nos_quatro_conexoes);
