CREATE TABLE area_montante_7538913 AS
SELECT * FROM area_contrib INNER JOIN (SELECT tr_m('7538913')) AS mont
ON mont.tr_m = area_contrib.cotrecho 