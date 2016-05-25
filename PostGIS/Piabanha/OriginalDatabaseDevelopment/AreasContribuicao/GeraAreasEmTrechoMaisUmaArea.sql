INSERT INTO trecho_mais_uma_area (gid_tr, gid_ac)
SELECT ta.gid_tr, ta.gid_ac FROM trecho_area AS ta INNER JOIN num_ac_trecho AS na ON ta.gid_tr = na.gid_tr WHERE na.num_ac > 1
ORDER BY ta.gid_tr