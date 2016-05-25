UPDATE hidrografia SET area_mont = ae.area_mont
FROM area_contrib_eq AS ae WHERE hidrografia.gid = ae.gid_tr