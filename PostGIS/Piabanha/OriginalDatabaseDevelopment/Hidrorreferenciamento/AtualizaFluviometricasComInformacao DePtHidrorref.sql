UPDATE fluviometricas SET cobacia = hr.cobacia
FROM pt_hidrorref AS hr WHERE fluviometricas.num = hr.num AND hr.tipo = 'postoflu';
UPDATE fluviometricas SET cocursodag = hr.cocursodag
FROM pt_hidrorref AS hr WHERE fluviometricas.num = hr.num AND hr.tipo = 'postoflu';
UPDATE fluviometricas SET geomproj_hr = hr.geom_pt_hr
FROM pt_hidrorref AS hr WHERE fluviometricas.num = hr.num AND hr.tipo = 'postoflu';
UPDATE fluviometricas SET dist_bac = hr.dist_bac
FROM pt_hidrorref AS hr WHERE fluviometricas.num = hr.num AND hr.tipo = 'postoflu';
UPDATE fluviometricas SET dist_hr = hr.dist_pt_tc
FROM pt_hidrorref AS hr WHERE fluviometricas.num = hr.num AND hr.tipo = 'postoflu';
UPDATE fluviometricas SET dist_cdag = NULL;
