-- Zera numero de conexoes na tabela nos
UPDATE nos SET num_conex = 0;
-- Gera o numero de conexões nos no_de
UPDATE nos SET num_conex = num_conex + nd.num_de FROM
(SELECT h.no_de, Count(h.no_de) AS num_de
FROM hidrografia AS h
GROUP BY h.no_de) AS nd
WHERE nos.id = nd.no_de;
-- Gera o numero de conexões nos no_para
UPDATE nos SET num_conex = num_conex + nd.num_para FROM
(SELECT h.no_para, Count(h.no_para) AS num_para
FROM hidrografia AS h
GROUP BY h.no_para) AS nd
WHERE nos.id = nd.no_para;
-- Gera o numero de conexões nos no_de na tabela hidrografia
UPDATE hidrografia SET no_de_num_conex = n.num_conex
FROM nos AS n
WHERE hidrografia.no_de = n.id;
-- Gera o numero de conexões nos no_para na tabela hidrografia
UPDATE hidrografia SET no_para_num_conex = n.num_conex
FROM nos AS n
WHERE hidrografia.no_para = n.id;