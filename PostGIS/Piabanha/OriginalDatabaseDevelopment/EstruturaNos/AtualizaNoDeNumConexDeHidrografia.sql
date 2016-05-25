UPDATE hidrografia SET no_de_num_conex = n.num_conex
FROM nos AS n
WHERE hidrografia.no_de = n.id;