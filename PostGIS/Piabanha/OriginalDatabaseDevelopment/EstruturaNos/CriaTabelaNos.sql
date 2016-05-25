CREATE TABLE nos
(
  id serial NOT NULL,
  geom geometry(Point,4326),
  geomproj geometry(Point,32723),
  num_conex integer,
  CONSTRAINT nos_pkey PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
