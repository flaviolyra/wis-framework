CREATE TABLE censo_basico_piabanha (gid_set_agr integer PRIMARY KEY, cod_setor character varying(20), cod_grande_regiao character varying(20),
  nome_grande_regiao character varying(60), cod_uf character varying(20), nome_uf  character varying(60), cod_meso character varying(20),
  nome_meso character varying(60), cod_micro character varying(20), nome_micro character varying(60), cod_rm character varying(20),
  nome_rm character varying(60), cod_municipio character varying(20), nome_municipio character varying(60), cod_distrito character varying(20),
  nome_distrito character varying(60), cod_subdistrito character varying(20), nome_subdistrito character varying(60), cod_bairro character varying(20),
  nome_bairro character varying(60), situacao_setor integer, v001 integer, v002 integer, v003 double precision, v004 double precision, v005 double precision,
  v006 double precision, v007 double precision, v008 double precision, v009 double precision, v010 double precision, v011 double precision,
  v012 double precision) WITH (OIDS=FALSE)