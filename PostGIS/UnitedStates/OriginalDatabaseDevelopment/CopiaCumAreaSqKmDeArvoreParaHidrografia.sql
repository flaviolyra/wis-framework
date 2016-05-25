UPDATE hidrografia SET cumareasqkm = a.cumareasqkm
FROM arvore_areas AS a WHERE hidrografia.comid = a.comid