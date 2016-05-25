INSERT INTO nos_trechos_4_conexoes (no_term, gid, compr, compracum, de_para)
SELECT no_term, gid, compr, compracum, de_para FROM
(SELECT h.gid, h.compr, a.compracum, h.no_de AS no_term, 'de' AS de_para
FROM hidrografia AS h INNER JOIN arvore_comprimentos AS a
ON h.gid = a.gid
WHERE h.no_de IN (SELECT id FROM nos WHERE num_conex = 4)
UNION
SELECT h.gid, h.compr, a.compracum, h.no_para AS no_term, 'para' de_para
FROM hidrografia AS h INNER JOIN arvore_comprimentos AS a
ON h.gid = a.gid
WHERE h.no_para IN (SELECT id FROM nos WHERE num_conex = 4)) AS t4c
ORDER BY no_term, compracum DESC;
