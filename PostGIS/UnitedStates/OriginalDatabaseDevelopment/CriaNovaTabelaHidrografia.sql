CREATE TABLE hidrografia (gid serial PRIMARY KEY, cotrecho integer, fromnode integer, tonode integer, divergence integer, lengthkm double precision,
  areasqkm double precision, ftype character varying(24), fcode integer, gnis_id character varying(10), noriocomp character varying(65),
  cobacia character varying(30), cocursodag character varying(30), corio character varying(30), cobacianum bigint, nudistbact double precision,
  nudistbacr double precision, nuareamont double precision, geom geometry(MultiLineStringZM,4269), geomproj geometry(MultiLineStringZM,5070))
WITH (OIDS=FALSE);
CREATE INDEX hidrografia_cotrecho_btree
  ON hidrografia
  USING btree
  (cotrecho );
CREATE INDEX hidrografia_cobacianum_btree
  ON hidrografia
  USING btree
  (cobacianum );
CREATE INDEX hidrografia_tonode_btree
  ON hidrografia
  USING btree
  (tonode );
CREATE INDEX hidrografia_geom_gist
  ON hidrografia
  USING gist
  (geom );
CREATE INDEX hidrografia_geomproj_uni_gist
  ON hidrografia
  USING gist
  (geomproj );
