UPDATE nos_quatro_conexoes SET geom_tr_montante = h.geomproj_uni
FROM hidrografia AS h
WHERE nos_quatro_conexoes.id_tr_montante = h.gid;
UPDATE nos_quatro_conexoes SET geom_tr_jusante = h.geomproj_uni
FROM hidrografia AS h
WHERE nos_quatro_conexoes.id_tr_jusante = h.gid;
UPDATE nos_quatro_conexoes SET geom_tr_afl_1 = h.geomproj_uni
FROM hidrografia AS h
WHERE nos_quatro_conexoes.id_tr_afl_1 = h.gid;
UPDATE nos_quatro_conexoes SET geom_tr_afl_2 = h.geomproj_uni
FROM hidrografia AS h
WHERE nos_quatro_conexoes.id_tr_afl_2 = h.gid;
UPDATE nos_quatro_conexoes SET geom_pt_confl = n.geomproj
FROM nos AS n
WHERE nos_quatro_conexoes.id_no = n.id;