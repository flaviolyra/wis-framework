CREATE TABLE divergencias
(
  gid serial NOT NULL,
  nodenumber integer,
  comid integer,
  statusflag character varying(1),
  divfrac double precision,
  CONSTRAINT divergencias_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
