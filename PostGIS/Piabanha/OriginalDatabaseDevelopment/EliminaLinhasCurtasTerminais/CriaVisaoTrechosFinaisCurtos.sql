CREATE OR REPLACE VIEW trechos_finais_curtos AS 
 SELECT h.gid, h.no_de, h.no_para, h.compr
   FROM hidrografia h
  WHERE h.compr < 50::double precision AND (h.no_de_num_conex = 1 OR h.no_para_num_conex = 1);
