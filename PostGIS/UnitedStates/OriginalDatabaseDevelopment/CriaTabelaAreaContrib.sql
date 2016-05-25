CREATE TABLE area_contrib (gid serial PRIMARY KEY, cotrecho integer, gridcode integer, sourcefc character varying(20), areasqkm double precision,
  geom geometry(MultiPolygon,4269), geomproj geometry(MultiPolygon,5070))
WITH (
  OIDS=FALSE
);
CREATE INDEX area_contrib_cotrecho_btree
  ON area_contrib
  USING btree
  (cotrecho );
CREATE INDEX area_contrib_geom_gist
  ON area_contrib
  USING gist
  (geom );
CREATE INDEX area_contrib_geomproj_gist
  ON area_contrib
  USING gist
  (geomproj );
