UPDATE barragens SET cobacia = hr.cobacia
FROM pt_hidrorref AS hr WHERE barragens.num = hr.num AND hr.tipo = 'barragem';
UPDATE barragens SET cocursodag = hr.cocursodag
FROM pt_hidrorref AS hr WHERE barragens.num = hr.num AND hr.tipo = 'barragem';
UPDATE barragens SET geomproj_hr = hr.geom_pt_hr
FROM pt_hidrorref AS hr WHERE barragens.num = hr.num AND hr.tipo = 'barragem';
UPDATE barragens SET dist_bac = hr.dist_bac
FROM pt_hidrorref AS hr WHERE barragens.num = hr.num AND hr.tipo = 'barragem';
UPDATE barragens SET dist_hr = hr.dist_pt_tc
FROM pt_hidrorref AS hr WHERE barragens.num = hr.num AND hr.tipo = 'barragem';
UPDATE barragens SET dist_cdag = NULL;
