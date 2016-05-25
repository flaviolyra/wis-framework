CREATE TABLE hidrografia
(
  gid serial NOT NULL,
  comid integer,
  fromnode integer,
  tonode integer,
  divergence integer,
  lengthkm double precision,
  areasqkm double precision,
  cumareasqkm double precision,
  geom geometry(MultiLineStringZM, 4269),
  CONSTRAINT hidrografia_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX hidrografia_comid_btree ON hidrografia USING btree (comid);
CREATE INDEX hidrografia_fromnode_btree ON hidrografia USING btree (fromnode);
CREATE INDEX hidrografia_tonode_btree ON hidrografia USING btree (tonode);

