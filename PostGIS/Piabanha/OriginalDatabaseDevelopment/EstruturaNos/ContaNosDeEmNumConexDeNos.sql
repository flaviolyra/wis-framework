UPDATE nos SET num_conex = num_conex + nd.num_de FROM
(SELECT h.no_de, Count(h.no_de) AS num_de
FROM hidrografia AS h
GROUP BY h.no_de) AS nd
WHERE nos.id = nd.no_de;