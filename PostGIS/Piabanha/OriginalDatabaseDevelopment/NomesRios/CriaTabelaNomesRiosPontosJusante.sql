CREATE TABLE nomes_rios_pontos_jusante
(
  gid_rio serial NOT NULL,
  nome_dre character varying(40),
  cobacia character varying(30),
  cocursodag character varying(30),
  area_mont double precision,
  fase_id_nomes integer,
  CONSTRAINT nomes_rios_pontos_jusante_pkey PRIMARY KEY (gid_rio )
)
WITH (
  OIDS=FALSE
);
