INSERT INTO buffers (gid_tr, distancia, geomproj)
SELECT gid, 500., ST_Buffer(geomproj_uni, 500.)
FROM hidrografia WHERE gid IN
(SELECT ta.gid_tr FROM trecho_area as ta INNER JOIN num_tr_area as nt ON ta.gid_ac = nt.gid_ac WHERE nt.num_tr > 1)