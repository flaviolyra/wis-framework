UPDATE area_contrib_eq SET area_mont = aa.areaacum
FROM arvore_areas AS aa WHERE area_contrib_eq.gid_tr = aa.gid