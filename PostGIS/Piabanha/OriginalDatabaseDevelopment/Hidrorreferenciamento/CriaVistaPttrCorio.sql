CREATE VIEW pttr_corio AS 
 SELECT t.num, t.tipo, t.nome, t.nome_alt, t.nome_rio, t.corio, t.hr_dir_ind, t.lat_pt_infl, t.long_pt_infl, t.geom_pt, t.dist_max, t.cobacia,
  t.cocursodag, st_line_interpolate_point(t.geom_tc, st_line_locate_point(t.geom_tc, t.geom_pt)) AS geom_pt_trc, t.dist_pt_tc,
  st_line_locate_point(t.geom_tc, t.geom_pt) AS dist_prop_trc, st_x(st_line_interpolate_point(t.geom_tc, st_line_locate_point(t.geom_tc, t.geom_pt))) AS x_pt_trc,
  st_y(st_line_interpolate_point(t.geom_tc, st_line_locate_point(t.geom_tc, t.geom_pt))) AS y_pt_trc, t.compr, t.compr_foz
   FROM ( SELECT DISTINCT ON (p.num, p.tipo) p.num, p.tipo, p.nome, p.nome_alt, p.nome_rio, p.corio, h.cobacia, p.hr_dir_ind, p.lat_pt_infl, p.long_pt_infl,
     p.dist_max, h.cocursodag, st_distance(h.geomproj_uni, p.geomproj) AS dist_pt_tc, p.geomproj AS geom_pt, h.geomproj_uni AS geom_tc, h.compr, h.compr_foz
           FROM pt_a_hidrorref AS p
      LEFT JOIN hidrografia AS h ON p.corio = h.corio AND st_dwithin(h.geomproj_uni, p.geomproj, p.dist_max)
     ORDER BY p.num, p.tipo, st_distance(h.geomproj_uni, p.geomproj)) AS t;
