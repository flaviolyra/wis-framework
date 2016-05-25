CREATE TABLE var_censit_acum_exp AS 
 SELECT vca.gid_tr, vca.id_var_censit, vc.descricao, round(vca.valacum) AS valor
 FROM var_censit_acum AS vca INNER JOIN variaveis_censitarias AS vc ON vca.id_var_censit = vc.id_var_censit
 ORDER BY vca.gid_tr, vca.id_var_censit