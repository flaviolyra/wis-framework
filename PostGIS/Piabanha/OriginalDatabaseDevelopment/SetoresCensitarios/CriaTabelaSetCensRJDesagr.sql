CREATE TABLE set_cens_rj_desagr (gid serial PRIMARY KEY, gid_agr integer, cd_geocodi character varying(20), geom_uni geometry(Polygon, 4326),
geomproj_uni geometry(Polygon, 32723)) WITH (OIDS=FALSE)