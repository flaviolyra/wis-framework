UPDATE nos_quatro_conexoes SET geom_ntr_afl_2 = CASE WHEN no_lig_tr_afl_2 = 'de'
  THEN ST_SetPoint(geom_tr_afl_2, 0, geom_npt_confl)
  ELSE ST_SetPoint(geom_tr_afl_2, ST_NumPoints(geom_tr_afl_2) - 1, geom_npt_confl)
  END
WHERE geom_ntr_afl_1 IS NULL;