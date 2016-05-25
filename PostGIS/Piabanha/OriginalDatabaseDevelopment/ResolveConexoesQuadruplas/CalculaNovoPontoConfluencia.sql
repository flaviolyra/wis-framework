UPDATE nos_quatro_conexoes SET geom_npt_confl = CASE WHEN no_lig_tr_montante = 'de'
  THEN ST_StartPoint(geom_ntr_montante)
  ELSE ST_EndPoint(geom_ntr_montante)
  END;