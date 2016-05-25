UPDATE nos SET num_conex = num_conex + nd.num_para FROM
(SELECT h.no_para, Count(h.no_para) AS num_para
FROM hidrografia AS h
GROUP BY h.no_para) AS nd
WHERE nos.id = nd.no_para;