CREATE TABLE uso_area_contrib (gid SERIAL PRIMARY KEY, gid_tr integer, id_uso integer, geomproj geometry, area double precision)
WITH (OIDS=FALSE)