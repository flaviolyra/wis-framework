INSERT INTO num_tr_area (gid_ac, num_tr)
SELECT gid_ac, count(gid_tr) AS num_tr FROM trecho_area GROUP BY gid_ac ORDER BY count(gid_tr) DESC