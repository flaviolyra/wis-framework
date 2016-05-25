UPDATE usinas SET cobacianum = rpad(cobacia,15,'0')::bigint;
UPDATE usinas SET geom_hr = ST_Transform(geomproj_hr, 4326);
