CREATE TABLE folha_anta
(
  gid serial NOT NULL,
  geomproj_69 geometry(LineString,29193),
  geomproj geometry(LineString,32723),
  CONSTRAINT folha_anta_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
)