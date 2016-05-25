CREATE OR REPLACE VIEW nos_terminais_proximos AS 
 SELECT n1.id AS id_no1, n1.geomproj AS geom_no1, n2.id AS id_no2, n2.geomproj AS geom_no2
   FROM nos n1
   JOIN nos n2 ON st_dwithin(n1.geomproj, n2.geomproj, 10::numeric::double precision) AND n1.id <> n2.id AND n1.num_conex = 1 AND n2.num_conex = 1;
