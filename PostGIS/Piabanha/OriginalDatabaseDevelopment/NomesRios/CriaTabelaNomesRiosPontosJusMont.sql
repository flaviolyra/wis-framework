CREATE TABLE nomes_rios_pontos_jus_mont
(
  gid_rio integer PRIMARY KEY,
  nome_dre character varying(40),
  cobac_jus character varying(30),
  cocurs_jus character varying(30),
  area_mont_jus double precision,
  cobac_mont character varying(30),
  cocurs_mont character varying(30),
  area_mont_mont double precision
)
WITH (
  OIDS=FALSE
);
