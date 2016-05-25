CREATE TABLE set_cens_area_contrib (gid SERIAL PRIMARY KEY, gid_tr integer, gid_set_desag integer, gid_set_agr integer, geomproj geometry, area double precision)
WITH (OIDS=FALSE)