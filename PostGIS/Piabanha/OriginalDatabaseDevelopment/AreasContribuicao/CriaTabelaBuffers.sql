CREATE TABLE buffers
(
  gid serial NOT NULL,
  gid_tr integer,
  distancia double precision,
  geomproj geometry(Polygon,32723),
  CONSTRAINT buffers_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
