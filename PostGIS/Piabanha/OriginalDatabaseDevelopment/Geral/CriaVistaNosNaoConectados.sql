CREATE OR REPLACE VIEW nos_nao_conectados AS 
 SELECT n1.id
   FROM nos n1
   JOIN nos n2 ON st_dwithin(n1.geomproj, n2.geomproj, 20.0::double precision) AND n1.num_conex = 1 AND n2.num_conex = 2;
