INSERT INTO folha_anta (geomproj_69)
SELECT ST_Scale((ST_Dump(geom)).geom, 1000., 1000., 1.) AS geomproj_69
FROM anta