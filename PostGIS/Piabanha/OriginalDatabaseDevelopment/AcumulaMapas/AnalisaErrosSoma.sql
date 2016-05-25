CREATE TABLE trechos_erros_soma AS
SELECT h.gid, h.area_mont/1000000. AS areamont, s.soma/1000000. AS somaareas, h.area_mont/s.soma AS perc FROM
hidrografia AS h INNER JOIN
(SELECT gid_tr, sum(valacum) as soma FROM mapa_acum_trecho GROUP BY gid_tr ORDER BY gid_tr) AS s
ON h.gid = s.gid_tr
WHERE h.area_mont/s.soma > 1.01
ORDER BY h.area_mont/s.soma DESC