CREATE TABLE arvore_areas
(
  gid integer NOT NULL,
  no_de integer,
  no_para integer,
  area double precision,
  areaacum double precision,
  CONSTRAINT arvore_areas_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
