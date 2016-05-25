CREATE VIEW pt_hidrorref AS 
 SELECT p.num, p.tipo, p.nome, p.nome_alt, p.nome_rio, p.corio, p.hr_dir_ind, p.lat_pt_infl, p.long_pt_infl, p.geom_pt, p.dist_max, p.cobacia, p.cocursodag,
   p.geom_pt_trc AS geom_pt_hr, p.compr_foz + (1. - p.dist_prop_trc) * p.compr AS dist_bac, p.dist_pt_tc
   FROM (SELECT num, tipo, nome, nome_alt, nome_rio, corio, hr_dir_ind, lat_pt_infl, long_pt_infl, geom_pt, dist_max, cobacia, cocursodag, geom_pt_trc,
          dist_pt_tc, dist_prop_trc, x_pt_trc, y_pt_trc, compr, compr_foz FROM pttr_corio) AS p;

