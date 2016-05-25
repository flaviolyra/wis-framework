CREATE OR REPLACE VIEW numero_conexoes AS 
 SELECT nos.num_conex, count(nos.id) AS count
   FROM nos
  GROUP BY nos.num_conex;
