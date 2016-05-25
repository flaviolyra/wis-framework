UPDATE nos_quatro_conexoes SET geom_ntr_afl_1 = NULL
WHERE ST_Intersects(geom_tr_afl_2, geom_ntr_afl_1);