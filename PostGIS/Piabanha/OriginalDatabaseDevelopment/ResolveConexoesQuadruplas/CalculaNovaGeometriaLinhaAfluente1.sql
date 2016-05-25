UPDATE nos_quatro_conexoes SET geom_ntr_afl_1 = CASE WHEN no_lig_tr_afl_1 = 'de'
  THEN ST_SetPoint(geom_tr_afl_1, 0, geom_npt_confl)
  ELSE ST_SetPoint(geom_tr_afl_1, ST_NumPoints(geom_tr_afl_1) - 1, geom_npt_confl)
  END;