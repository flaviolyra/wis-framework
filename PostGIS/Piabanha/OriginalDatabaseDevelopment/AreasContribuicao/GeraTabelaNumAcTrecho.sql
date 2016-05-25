INSERT INTO num_ac_trecho (gid_tr, num_ac)
SELECT gid_tr, count(gid_ac) AS num_ac FROM trecho_area GROUP BY gid_tr ORDER BY count(gid_ac) DESC