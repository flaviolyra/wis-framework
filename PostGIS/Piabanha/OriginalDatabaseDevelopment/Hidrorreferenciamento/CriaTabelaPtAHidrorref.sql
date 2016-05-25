CREATE TABLE pt_a_hidrorref
(
  gid serial NOT NULL,
  num integer,
  tipo character varying(254),
  nome character varying(254),
  nome_alt character varying(254),
  nome_rio character varying(254),
  corio character varying(254),
  cobacia character varying(254),
  hr_dir_ind text,
  lat_pt_infl double precision,
  long_pt_infl double precision,
  geomproj geometry(Point,32723),
  dist_max double precision,
  CONSTRAINT pt_a_hidrorref_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX pt_a_hidrorref_cobacia_btree
  ON pt_a_hidrorref
  USING btree
  (cobacia COLLATE pg_catalog."default" );
CREATE INDEX pt_a_hidrorref_geomproj_gist
  ON pt_a_hidrorref
  USING gist
  (geomproj );
