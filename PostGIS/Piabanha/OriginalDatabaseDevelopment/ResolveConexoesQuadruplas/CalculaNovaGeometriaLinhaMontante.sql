UPDATE nos_quatro_conexoes SET geom_ntr_montante = CASE WHEN no_lig_tr_montante = 'de'
  THEN ST_Line_Substring(geom_tr_montante, 20. / ST_Length2d(geom_tr_montante), 1.)
  ELSE ST_Line_Substring(geom_tr_montante, 0., 1. - (20. / ST_Length2d(geom_tr_montante)))
  END;