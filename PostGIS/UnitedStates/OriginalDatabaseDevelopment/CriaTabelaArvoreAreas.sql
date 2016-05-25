CREATE TABLE arvore_areas
(
  gid serial NOT NULL,
  comid integer,
  fromnode integer,
  tonode integer,
  lengthkm double precision,
  areasqkm double precision,
  cumareasqkm double precision,
  CONSTRAINT arvore_areas_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
