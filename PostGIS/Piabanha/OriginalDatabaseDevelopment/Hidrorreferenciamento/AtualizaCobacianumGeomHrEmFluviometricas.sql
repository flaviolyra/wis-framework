UPDATE fluviometricas SET cobacianum = rpad(cobacia,15,'0')::bigint;
UPDATE fluviometricas SET geom_hr = ST_Transform(geomproj_hr, 4326);
