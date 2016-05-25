CREATE TABLE setores_censitarios_piabanha
(
  gid serial NOT NULL,
  id double precision,
  cd_geocodi character varying(20),
  tipo character varying(10),
  cd_geocodb character varying(20),
  nm_bairro character varying(60),
  cd_geocods character varying(20),
  nm_subdist character varying(60),
  cd_geocodd character varying(20),
  nm_distrit character varying(60),
  cd_geocodm character varying(20),
  nm_municip character varying(60),
  nm_micro character varying(100),
  nm_meso character varying(100),
  geom geometry(MultiPolygonM,4674),
  num_geometrias integer,
  geomproj geometry(MultiPolygonM,32723),
  CONSTRAINT setores_censitarios_piabanha_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
