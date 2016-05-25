CREATE OR REPLACE VIEW linhas_proximas_linhas_terminais AS 
 SELECT lpt.gid AS gid_lpt, lpt.no_de AS no_de_lpt, lpt.no_para AS no_para_lpt, lpt.no_term, lpt.geom_ln AS geom_lpt, lpt.geom_pt, h.gid AS gid_lo, h.geomproj_uni AS geom_lo
   FROM linhas_pontos_terminais lpt
   JOIN hidrografia h ON st_dwithin(lpt.geom_pt, h.geomproj_uni, 50::numeric::double precision)
  WHERE lpt.gid <> h.gid;
