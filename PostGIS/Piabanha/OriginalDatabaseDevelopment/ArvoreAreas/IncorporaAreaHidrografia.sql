UPDATE hidrografia SET area = ae.area
FROM area_contrib_eq AS ae WHERE hidrografia.gid = ae.gid_tr