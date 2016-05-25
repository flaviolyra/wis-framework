CREATE OR REPLACE VIEW pontas_proximas_a_juncoes AS 
 SELECT n1.id AS id_1, n2.id AS id_2
   FROM nos n1
   JOIN nos n2 ON st_dwithin(n1.geomproj, n2.geomproj, 50::double precision)
  WHERE n1.num_conex = 1 AND n2.num_conex = 2;
