UPDATE hidrografia SET no_para_num_conex = n.num_conex
FROM nos AS n
WHERE hidrografia.no_para = n.id;