INSERT INTO hidrografia (cotrecho, fromnode, tonode, divergence, lengthkm, areasqkm, ftype, fcode, gnis_id, noriocomp, cobacia, cocursodag, corio,
  cobacianum, nudistbact, nudistbacr, nuareamont, geom)
SELECT comid, fromnode, tonode, divergence, lengthkm, areasqkm, ftype, fcode, gnis_id, gnis_name, cobacia, cocursodag, corio, cobacianum, pathlength,
  nudistbacr, cumareasqkm, geom FROM hidrografia_orig;