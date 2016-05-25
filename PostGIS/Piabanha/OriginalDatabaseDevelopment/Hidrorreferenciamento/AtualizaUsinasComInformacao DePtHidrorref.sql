UPDATE usinas SET cobacia = hr.cobacia
FROM pt_hidrorref AS hr WHERE usinas.num = hr.num AND hr.tipo = 'usina';
UPDATE usinas SET cocursodag = hr.cocursodag
FROM pt_hidrorref AS hr WHERE usinas.num = hr.num AND hr.tipo = 'usina';
UPDATE usinas SET geomproj_hr = hr.geom_pt_hr
FROM pt_hidrorref AS hr WHERE usinas.num = hr.num AND hr.tipo = 'usina';
UPDATE usinas SET dist_bac = hr.dist_bac
FROM pt_hidrorref AS hr WHERE usinas.num = hr.num AND hr.tipo = 'usina';
UPDATE usinas SET dist_hr = hr.dist_pt_tc
FROM pt_hidrorref AS hr WHERE usinas.num = hr.num AND hr.tipo = 'usina';
UPDATE usinas SET dist_cdag = NULL;
