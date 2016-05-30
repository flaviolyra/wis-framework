--
-- Cria Tabela aplicativo_informacoes
--
CREATE TABLE aplicativo_informacoes
(
  gid serial NOT NULL,
  variavel character varying(30),
  topologia character varying(20),
  forma character varying(20),
  tabela character varying(30),
  tabela_chave character varying(30),
  metodo character varying(50),
  CONSTRAINT aplicativo_informacoes_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela area_contrib
--
CREATE TABLE area_contrib
(
  gid integer NOT NULL,
  cotrecho integer,
  cobacia character varying(30),
  cobacianum bigint,
  geom geometry(Polygon,4326),
  geomproj geometry(Polygon,32723),
  area double precision,
  area_mont double precision,
  CONSTRAINT ar_contr_eq_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX area_contrib_cotrecho_btree
  ON area_contrib
  USING btree
  (cotrecho );
CREATE INDEX area_contrib_eq_geomproj_gist
  ON area_contrib
  USING gist
  (geomproj );
CREATE INDEX area_contrib_geom_gist
  ON area_contrib
  USING gist
  (geom );
--
-- Cria Tabela arvore_areas
--
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
--
-- Cria Tabela arvore_comprimentos
--
CREATE TABLE arvore_comprimentos
(
  gid integer NOT NULL,
  no_de integer,
  no_para integer,
  compr double precision,
  compracum double precision,
  CONSTRAINT arvore_comprimentos_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela bacia
--
CREATE TABLE bacia
(
  gid serial NOT NULL,
  id double precision,
  geomproj geometry(MultiPolygon,32723),
  geom_uni geometry(Polygon,4326),
  geomproj_uni geometry(Polygon,32723),
  CONSTRAINT bacia_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX bacia_geomproj_gist
  ON bacia
  USING gist
  (geomproj );
--
-- Cria Tabela barragens
--
CREATE TABLE barragens
(
  num integer NOT NULL,
  nome character varying(254),
  nome_alt character varying(254),
  latitude double precision,
  longitude double precision,
  cod_mun_1 character varying(10),
  nome_mun_1 character varying(254),
  uf_1 character varying(10),
  reg_geog_1 character varying(50),
  cod_mun_2 character varying(10),
  nome_mun_2 character varying(254),
  uf_2 character varying(10),
  reg_geog_2 character varying(50),
  nome_rio character varying(254),
  corio character varying(50),
  cocursodag character varying(50),
  cobacia character varying(50),
  dist_cdag double precision,
  dist_bac double precision,
  cobacianum bigint,
  dist_hr double precision,
  reg_hidrog character varying(50),
  cod_bac_dn integer,
  cod_sb_dn integer,
  camin_imag character varying(100),
  geom geometry(Point,4326),
  geomproj geometry(Point,32723),
  geom_hr geometry(Point,4326),
  geomproj_hr geometry(Point,32723),
  num_ons integer,
  hr_dir_ind character varying(10),
  cotrecho integer,
  CONSTRAINT barragens_pkey PRIMARY KEY (num )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX barragens_geom_gist
  ON barragens
  USING gist
  (geom );
CREATE INDEX barragens_geom_hr_gist
  ON barragens
  USING gist
  (geom_hr );
CREATE INDEX barragens_geomproj_gist
  ON barragens
  USING gist
  (geomproj );
CREATE INDEX barragens_geomproj_hr_gist
  ON barragens
  USING gist
  (geomproj_hr );
--
-- Cria Tabela censo_basico
--
CREATE TABLE censo_basico
(
  gid serial NOT NULL,
  cod_setor character varying(20),
  cod_grande_regiao character varying(20),
  nome_grande_regiao character varying(60),
  cod_uf character varying(20),
  nome_uf character varying(60),
  cod_meso character varying(20),
  nome_meso character varying(60),
  cod_micro character varying(20),
  nome_micro character varying(60),
  cod_rm character varying(20),
  nome_rm character varying(60),
  cod_municipio character varying(20),
  nome_municipio character varying(60),
  cod_distrito character varying(20),
  nome_distrito character varying(60),
  cod_subdistrito character varying(20),
  nome_subdistrito character varying(60),
  cod_bairro character varying(20),
  nome_bairro character varying(60),
  situacao_setor integer,
  v001 integer,
  v002 integer,
  v003 double precision,
  v004 double precision,
  v005 double precision,
  v006 double precision,
  v007 double precision,
  v008 double precision,
  v009 double precision,
  v010 double precision,
  v011 double precision,
  v012 double precision,
  CONSTRAINT censo_basico_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX censo_basico_cod_setor_btree
  ON censo_basico
  USING btree
  (cod_setor COLLATE pg_catalog."default" );
--
-- Cria Tabela censo_basico_piabanha
--
CREATE TABLE censo_basico_piabanha
(
  gid_set_agr integer NOT NULL,
  cod_setor character varying(20),
  cod_grande_regiao character varying(20),
  nome_grande_regiao character varying(60),
  cod_uf character varying(20),
  nome_uf character varying(60),
  cod_meso character varying(20),
  nome_meso character varying(60),
  cod_micro character varying(20),
  nome_micro character varying(60),
  cod_rm character varying(20),
  nome_rm character varying(60),
  cod_municipio character varying(20),
  nome_municipio character varying(60),
  cod_distrito character varying(20),
  nome_distrito character varying(60),
  cod_subdistrito character varying(20),
  nome_subdistrito character varying(60),
  cod_bairro character varying(20),
  nome_bairro character varying(60),
  situacao_setor integer,
  v001 integer,
  v002 integer,
  v003 double precision,
  v004 double precision,
  v005 double precision,
  v006 double precision,
  v007 double precision,
  v008 double precision,
  v009 double precision,
  v010 double precision,
  v011 double precision,
  v012 double precision,
  CONSTRAINT censo_basico_piabanha_pkey PRIMARY KEY (gid_set_agr )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela censo_domicilio01
--
CREATE TABLE censo_domicilio01
(
  gid serial NOT NULL,
  cod_setor character varying(20),
  situacao_setor integer,
  v001 integer,
  v002 integer,
  v003 integer,
  v004 integer,
  v005 integer,
  v006 integer,
  v007 integer,
  v008 integer,
  v009 integer,
  v010 integer,
  v011 integer,
  v012 integer,
  v013 integer,
  v014 integer,
  v015 integer,
  v016 integer,
  v017 integer,
  v018 integer,
  v019 integer,
  v020 integer,
  v021 integer,
  v022 integer,
  v023 integer,
  v024 integer,
  v025 integer,
  v026 integer,
  v027 integer,
  v028 integer,
  v029 integer,
  v030 integer,
  v031 integer,
  v032 integer,
  v033 integer,
  v034 integer,
  v035 integer,
  v036 integer,
  v037 integer,
  v038 integer,
  v039 integer,
  v040 integer,
  v041 integer,
  v042 integer,
  v043 integer,
  v044 integer,
  v045 integer,
  v046 integer,
  v047 integer,
  v048 integer,
  v049 integer,
  v050 integer,
  v051 integer,
  v052 integer,
  v053 integer,
  v054 integer,
  v055 integer,
  v056 integer,
  v057 integer,
  v058 integer,
  v059 integer,
  v060 integer,
  v061 integer,
  v062 integer,
  v063 integer,
  v064 integer,
  v065 integer,
  v066 integer,
  v067 integer,
  v068 integer,
  v069 integer,
  v070 integer,
  v071 integer,
  v072 integer,
  v073 integer,
  v074 integer,
  v075 integer,
  v076 integer,
  v077 integer,
  v078 integer,
  v079 integer,
  v080 integer,
  v081 integer,
  v082 integer,
  v083 integer,
  v084 integer,
  v085 integer,
  v086 integer,
  v087 integer,
  v088 integer,
  v089 integer,
  v090 integer,
  v091 integer,
  v092 integer,
  v093 integer,
  v094 integer,
  v095 integer,
  v096 integer,
  v097 integer,
  v098 integer,
  v099 integer,
  v100 integer,
  v101 integer,
  v102 integer,
  v103 integer,
  v104 integer,
  v105 integer,
  v106 integer,
  v107 integer,
  v108 integer,
  v109 integer,
  v110 integer,
  v111 integer,
  v112 integer,
  v113 integer,
  v114 integer,
  v115 integer,
  v116 integer,
  v117 integer,
  v118 integer,
  v119 integer,
  v120 integer,
  v121 integer,
  v122 integer,
  v123 integer,
  v124 integer,
  v125 integer,
  v126 integer,
  v127 integer,
  v128 integer,
  v129 integer,
  v130 integer,
  v131 integer,
  v132 integer,
  v133 integer,
  v134 integer,
  v135 integer,
  v136 integer,
  v137 integer,
  v138 integer,
  v139 integer,
  v140 integer,
  v141 integer,
  v142 integer,
  v143 integer,
  v144 integer,
  v145 integer,
  v146 integer,
  v147 integer,
  v148 integer,
  v149 integer,
  v150 integer,
  v151 integer,
  v152 integer,
  v153 integer,
  v154 integer,
  v155 integer,
  v156 integer,
  v157 integer,
  v158 integer,
  v159 integer,
  v160 integer,
  v161 integer,
  v162 integer,
  v163 integer,
  v164 integer,
  v165 integer,
  v166 integer,
  v167 integer,
  v168 integer,
  v169 integer,
  v170 integer,
  v171 integer,
  v172 integer,
  v173 integer,
  v174 integer,
  v175 integer,
  v176 integer,
  v177 integer,
  v178 integer,
  v179 integer,
  v180 integer,
  v181 integer,
  v182 integer,
  v183 integer,
  v184 integer,
  v185 integer,
  v186 integer,
  v187 integer,
  v188 integer,
  v189 integer,
  v190 integer,
  v191 integer,
  v192 integer,
  v193 integer,
  v194 integer,
  v195 integer,
  v196 integer,
  v197 integer,
  v198 integer,
  v199 integer,
  v200 integer,
  v201 integer,
  v202 integer,
  v203 integer,
  v204 integer,
  v205 integer,
  v206 integer,
  v207 integer,
  v208 integer,
  v209 integer,
  v210 integer,
  v211 integer,
  v212 integer,
  v213 integer,
  v214 integer,
  v215 integer,
  v216 integer,
  v217 integer,
  v218 integer,
  v219 integer,
  v220 integer,
  v221 integer,
  v222 integer,
  v223 integer,
  v224 integer,
  v225 integer,
  v226 integer,
  v227 integer,
  v228 integer,
  v229 integer,
  v230 integer,
  v231 integer,
  v232 integer,
  v233 integer,
  v234 integer,
  v235 integer,
  v236 integer,
  v237 integer,
  v238 integer,
  v239 integer,
  v240 integer,
  v241 integer,
  CONSTRAINT censo_domicilio01_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX censo_domicilio01_cod_setor_btree
  ON censo_domicilio01
  USING btree
  (cod_setor COLLATE pg_catalog."default" );
--
-- Cria Tabela censo_domicilio01_piabanha
--
CREATE TABLE censo_domicilio01_piabanha
(
  gid_set_agr integer NOT NULL,
  cod_setor character varying(20),
  situacao_setor integer,
  v001 integer,
  v002 integer,
  v003 integer,
  v004 integer,
  v005 integer,
  v006 integer,
  v007 integer,
  v008 integer,
  v009 integer,
  v010 integer,
  v011 integer,
  v012 integer,
  v013 integer,
  v014 integer,
  v015 integer,
  v016 integer,
  v017 integer,
  v018 integer,
  v019 integer,
  v020 integer,
  v021 integer,
  v022 integer,
  v023 integer,
  v024 integer,
  v025 integer,
  v026 integer,
  v027 integer,
  v028 integer,
  v029 integer,
  v030 integer,
  v031 integer,
  v032 integer,
  v033 integer,
  v034 integer,
  v035 integer,
  v036 integer,
  v037 integer,
  v038 integer,
  v039 integer,
  v040 integer,
  v041 integer,
  v042 integer,
  v043 integer,
  v044 integer,
  v045 integer,
  v046 integer,
  v047 integer,
  v048 integer,
  v049 integer,
  v050 integer,
  v051 integer,
  v052 integer,
  v053 integer,
  v054 integer,
  v055 integer,
  v056 integer,
  v057 integer,
  v058 integer,
  v059 integer,
  v060 integer,
  v061 integer,
  v062 integer,
  v063 integer,
  v064 integer,
  v065 integer,
  v066 integer,
  v067 integer,
  v068 integer,
  v069 integer,
  v070 integer,
  v071 integer,
  v072 integer,
  v073 integer,
  v074 integer,
  v075 integer,
  v076 integer,
  v077 integer,
  v078 integer,
  v079 integer,
  v080 integer,
  v081 integer,
  v082 integer,
  v083 integer,
  v084 integer,
  v085 integer,
  v086 integer,
  v087 integer,
  v088 integer,
  v089 integer,
  v090 integer,
  v091 integer,
  v092 integer,
  v093 integer,
  v094 integer,
  v095 integer,
  v096 integer,
  v097 integer,
  v098 integer,
  v099 integer,
  v100 integer,
  v101 integer,
  v102 integer,
  v103 integer,
  v104 integer,
  v105 integer,
  v106 integer,
  v107 integer,
  v108 integer,
  v109 integer,
  v110 integer,
  v111 integer,
  v112 integer,
  v113 integer,
  v114 integer,
  v115 integer,
  v116 integer,
  v117 integer,
  v118 integer,
  v119 integer,
  v120 integer,
  v121 integer,
  v122 integer,
  v123 integer,
  v124 integer,
  v125 integer,
  v126 integer,
  v127 integer,
  v128 integer,
  v129 integer,
  v130 integer,
  v131 integer,
  v132 integer,
  v133 integer,
  v134 integer,
  v135 integer,
  v136 integer,
  v137 integer,
  v138 integer,
  v139 integer,
  v140 integer,
  v141 integer,
  v142 integer,
  v143 integer,
  v144 integer,
  v145 integer,
  v146 integer,
  v147 integer,
  v148 integer,
  v149 integer,
  v150 integer,
  v151 integer,
  v152 integer,
  v153 integer,
  v154 integer,
  v155 integer,
  v156 integer,
  v157 integer,
  v158 integer,
  v159 integer,
  v160 integer,
  v161 integer,
  v162 integer,
  v163 integer,
  v164 integer,
  v165 integer,
  v166 integer,
  v167 integer,
  v168 integer,
  v169 integer,
  v170 integer,
  v171 integer,
  v172 integer,
  v173 integer,
  v174 integer,
  v175 integer,
  v176 integer,
  v177 integer,
  v178 integer,
  v179 integer,
  v180 integer,
  v181 integer,
  v182 integer,
  v183 integer,
  v184 integer,
  v185 integer,
  v186 integer,
  v187 integer,
  v188 integer,
  v189 integer,
  v190 integer,
  v191 integer,
  v192 integer,
  v193 integer,
  v194 integer,
  v195 integer,
  v196 integer,
  v197 integer,
  v198 integer,
  v199 integer,
  v200 integer,
  v201 integer,
  v202 integer,
  v203 integer,
  v204 integer,
  v205 integer,
  v206 integer,
  v207 integer,
  v208 integer,
  v209 integer,
  v210 integer,
  v211 integer,
  v212 integer,
  v213 integer,
  v214 integer,
  v215 integer,
  v216 integer,
  v217 integer,
  v218 integer,
  v219 integer,
  v220 integer,
  v221 integer,
  v222 integer,
  v223 integer,
  v224 integer,
  v225 integer,
  v226 integer,
  v227 integer,
  v228 integer,
  v229 integer,
  v230 integer,
  v231 integer,
  v232 integer,
  v233 integer,
  v234 integer,
  v235 integer,
  v236 integer,
  v237 integer,
  v238 integer,
  v239 integer,
  v240 integer,
  v241 integer,
  CONSTRAINT censo_domicilio01_piabanha_pkey PRIMARY KEY (gid_set_agr )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela censo_domicilio02
--
CREATE TABLE censo_domicilio02
(
  gid serial NOT NULL,
  cod_setor character varying(20),
  situacao_setor integer,
  v001 integer,
  v002 integer,
  v003 integer,
  v004 integer,
  v005 integer,
  v006 integer,
  v007 integer,
  v008 integer,
  v009 integer,
  v010 integer,
  v011 integer,
  v012 integer,
  v013 integer,
  v014 integer,
  v015 integer,
  v016 integer,
  v017 integer,
  v018 integer,
  v019 integer,
  v020 integer,
  v021 integer,
  v022 integer,
  v023 integer,
  v024 integer,
  v025 integer,
  v026 integer,
  v027 integer,
  v028 integer,
  v029 integer,
  v030 integer,
  v031 integer,
  v032 integer,
  v033 integer,
  v034 integer,
  v035 integer,
  v036 integer,
  v037 integer,
  v038 integer,
  v039 integer,
  v040 integer,
  v041 integer,
  v042 integer,
  v043 integer,
  v044 integer,
  v045 integer,
  v046 integer,
  v047 integer,
  v048 integer,
  v049 integer,
  v050 integer,
  v051 integer,
  v052 integer,
  v053 integer,
  v054 integer,
  v055 integer,
  v056 integer,
  v057 integer,
  v058 integer,
  v059 integer,
  v060 integer,
  v061 integer,
  v062 integer,
  v063 integer,
  v064 integer,
  v065 integer,
  v066 integer,
  v067 integer,
  v068 integer,
  v069 integer,
  v070 integer,
  v071 integer,
  v072 integer,
  v073 integer,
  v074 integer,
  v075 integer,
  v076 integer,
  v077 integer,
  v078 integer,
  v079 integer,
  v080 integer,
  v081 integer,
  v082 integer,
  v083 integer,
  v084 integer,
  v085 integer,
  v086 integer,
  v087 integer,
  v088 integer,
  v089 integer,
  v090 integer,
  v091 integer,
  v092 integer,
  v093 integer,
  v094 integer,
  v095 integer,
  v096 integer,
  v097 integer,
  v098 integer,
  v099 integer,
  v100 integer,
  v101 integer,
  v102 integer,
  v103 integer,
  v104 integer,
  v105 integer,
  v106 integer,
  v107 integer,
  v108 integer,
  v109 integer,
  v110 integer,
  v111 integer,
  v112 integer,
  v113 integer,
  v114 integer,
  v115 integer,
  v116 integer,
  v117 integer,
  v118 integer,
  v119 integer,
  v120 integer,
  v121 integer,
  v122 integer,
  v123 integer,
  v124 integer,
  v125 integer,
  v126 integer,
  v127 integer,
  v128 integer,
  v129 integer,
  v130 integer,
  v131 integer,
  v132 integer,
  CONSTRAINT censo_domicilio02_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX censo_domicilio02_cod_setor_btree
  ON censo_domicilio02
  USING btree
  (cod_setor COLLATE pg_catalog."default" );
--
-- Cria Tabela censo_domicilio02_piabanha
--
CREATE TABLE censo_domicilio02_piabanha
(
  gid_set_agr integer NOT NULL,
  cod_setor character varying(20),
  situacao_setor integer,
  v001 integer,
  v002 integer,
  v003 integer,
  v004 integer,
  v005 integer,
  v006 integer,
  v007 integer,
  v008 integer,
  v009 integer,
  v010 integer,
  v011 integer,
  v012 integer,
  v013 integer,
  v014 integer,
  v015 integer,
  v016 integer,
  v017 integer,
  v018 integer,
  v019 integer,
  v020 integer,
  v021 integer,
  v022 integer,
  v023 integer,
  v024 integer,
  v025 integer,
  v026 integer,
  v027 integer,
  v028 integer,
  v029 integer,
  v030 integer,
  v031 integer,
  v032 integer,
  v033 integer,
  v034 integer,
  v035 integer,
  v036 integer,
  v037 integer,
  v038 integer,
  v039 integer,
  v040 integer,
  v041 integer,
  v042 integer,
  v043 integer,
  v044 integer,
  v045 integer,
  v046 integer,
  v047 integer,
  v048 integer,
  v049 integer,
  v050 integer,
  v051 integer,
  v052 integer,
  v053 integer,
  v054 integer,
  v055 integer,
  v056 integer,
  v057 integer,
  v058 integer,
  v059 integer,
  v060 integer,
  v061 integer,
  v062 integer,
  v063 integer,
  v064 integer,
  v065 integer,
  v066 integer,
  v067 integer,
  v068 integer,
  v069 integer,
  v070 integer,
  v071 integer,
  v072 integer,
  v073 integer,
  v074 integer,
  v075 integer,
  v076 integer,
  v077 integer,
  v078 integer,
  v079 integer,
  v080 integer,
  v081 integer,
  v082 integer,
  v083 integer,
  v084 integer,
  v085 integer,
  v086 integer,
  v087 integer,
  v088 integer,
  v089 integer,
  v090 integer,
  v091 integer,
  v092 integer,
  v093 integer,
  v094 integer,
  v095 integer,
  v096 integer,
  v097 integer,
  v098 integer,
  v099 integer,
  v100 integer,
  v101 integer,
  v102 integer,
  v103 integer,
  v104 integer,
  v105 integer,
  v106 integer,
  v107 integer,
  v108 integer,
  v109 integer,
  v110 integer,
  v111 integer,
  v112 integer,
  v113 integer,
  v114 integer,
  v115 integer,
  v116 integer,
  v117 integer,
  v118 integer,
  v119 integer,
  v120 integer,
  v121 integer,
  v122 integer,
  v123 integer,
  v124 integer,
  v125 integer,
  v126 integer,
  v127 integer,
  v128 integer,
  v129 integer,
  v130 integer,
  v131 integer,
  v132 integer,
  CONSTRAINT censo_domicilio02_piabanha_pkey PRIMARY KEY (gid_set_agr )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela cod_pfaff_compr_mont
--
CREATE TABLE cod_pfaff_compr_mont
(
  gid integer,
  cobacia character varying(30),
  cocursodag character varying(30),
  dir_confl character varying(3)
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela compr_foz
--
CREATE TABLE compr_foz
(
  gid integer NOT NULL,
  compr double precision,
  CONSTRAINT compr_foz_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela fluviometricas
--
CREATE TABLE fluviometricas
(
  gid serial NOT NULL,
  codigo integer,
  nome character varying(254),
  riocodigo integer,
  nome_rio character varying(254),
  lat_pflu double precision,
  long_pflu double precision,
  altitude double precision,
  area_dren double precision,
  corio character varying(254),
  cocursodag character varying(254),
  cobacia character varying(254),
  dist_cdag double precision,
  dist_bac double precision,
  geom geometry(Point,4326),
  cobacianum bigint,
  geom_hr geometry(Point,4326),
  geomproj_hr geometry(Point,32723),
  geomproj geometry(Point,32723),
  dist_hr double precision,
  num integer,
  hr_dir_ind character varying(10),
  cotrecho integer,
  CONSTRAINT fluviometricas_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX fluviometricas_geom_gist
  ON fluviometricas
  USING gist
  (geom );
CREATE INDEX fluviometricas_geom_hr_gist
  ON fluviometricas
  USING gist
  (geom_hr );
CREATE INDEX fluviometricas_geomproj_gist
  ON fluviometricas
  USING gist
  (geomproj );
CREATE INDEX fluviometricas_geomproj_hr_gist
  ON fluviometricas
  USING gist
  (geomproj_hr );
--
-- Cria Tabela folhas_bacia
--
CREATE TABLE folhas_bacia
(
  gid integer NOT NULL,
  indnomencl character varying(18),
  metodoprod character varying(50),
  mi character varying(11),
  nome character varying(65),
  orgaoedito character varying(30),
  tipocarta character varying(40),
  anorestitu character varying(30),
  anoreambul character varying(30),
  anovoo character varying(30),
  areafolha character varying(30),
  latlimnort character varying(11),
  latlimsul character varying(11),
  longlimles character varying(11),
  longlimoes character varying(11),
  recursooff character varying(25),
  recursoonl character varying(200),
  uf character varying(25),
  declinacao character varying(50),
  datumhoriz character varying(60),
  datumverti character varying(30),
  meridianoc character varying(6),
  sistemapro character varying(30),
  anoedicao character varying(26),
  numedicao character varying(26),
  anoimpress character varying(26),
  numimpress character varying(26),
  geopdf character varying(3),
  pdf character varying(3),
  metadadoim character varying(13),
  id numeric(10,0),
  primaryind numeric(10,0),
  geom geometry(MultiPolygon,4326),
  geomproj geometry(MultiPolygon,32723),
  CONSTRAINT folhas_bacia_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela hidrografia
--
CREATE TABLE hidrografia
(
  gid serial NOT NULL,
  noriocomp character varying(40),
  compr double precision,
  no_de integer,
  no_para integer,
  geom geometry(LineString,4326),
  geomproj geometry(LineString,32723),
  no_de_num_conex integer,
  no_para_num_conex integer,
  compr_mont double precision,
  cocursodag character varying(30),
  cobacia character varying(30),
  cobacianum bigint,
  dir_confl character varying(3),
  area double precision,
  area_mont double precision,
  fase_id_nomes integer,
  corio character varying(30),
  compr_foz double precision,
  compr_foz_rio double precision,
  cotrecho integer,
  nudistbact double precision,
  nuareamont double precision,
  nudistbacr double precision,
  CONSTRAINT hidrografia_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX hidrografia_cobacianum_btree
  ON hidrografia
  USING btree
  (cobacianum );
CREATE INDEX hidrografia_cotrecho_btree
  ON hidrografia
  USING btree
  (cotrecho );
CREATE INDEX hidrografia_geom_gist
  ON hidrografia
  USING gist
  (geom );
CREATE INDEX hidrografia_geomproj_uni_gist
  ON hidrografia
  USING gist
  (geomproj );
CREATE INDEX hidrografia_node
  ON hidrografia
  USING btree
  (no_de );
CREATE INDEX hidrografia_nopara
  ON hidrografia
  USING btree
  (no_para );
--
-- Cria Tabela localidades2010
--
CREATE TABLE localidades2010
(
  gid serial NOT NULL,
  id numeric(10,0),
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
  nm_uf character varying(60),
  cd_nivel character varying(1),
  cd_categor character varying(5),
  nm_categor character varying(50),
  nm_localid character varying(60),
  "long" numeric,
  lat numeric,
  alt numeric,
  gmrotation numeric,
  geom geometry(Point,4326),
  geomproj geometry(Point,32723),
  CONSTRAINT localidades2010_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX localidades2010_geom_gist
  ON localidades2010
  USING gist
  (geom );
CREATE INDEX localidades2010_geomproj_gist
  ON localidades2010
  USING gist
  (geomproj );
--
-- Cria Tabela localidades2010_piabanha
--
CREATE TABLE localidades2010_piabanha
(
  gid integer NOT NULL,
  id numeric(10,0),
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
  nm_uf character varying(60),
  cd_nivel character varying(1),
  cd_categor character varying(5),
  nm_categor character varying(50),
  nm_localid character varying(60),
  "long" numeric,
  lat numeric,
  alt numeric,
  gmrotation numeric,
  geom geometry(Point,4326),
  geomproj geometry(Point,32723),
  CONSTRAINT localidades2010_piabanha_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX localidades2010_piabanha_geom_gist
  ON localidades2010_piabanha
  USING gist
  (geom );
CREATE INDEX localidades2010_piabanha_geomproj_gist
  ON localidades2010_piabanha
  USING gist
  (geomproj );
--
-- Cria Tabela localidades_areas_2010
--
CREATE TABLE localidades_areas_2010
(
  gid serial NOT NULL,
  id_nucleo integer,
  id_localidade integer,
  geom geometry(Polygon,4326),
  geomproj geometry(Polygon,32723),
  cd_geocodd character varying(20),
  nm_distrit character varying(60),
  cd_geocodm character varying(20),
  nm_municip character varying(60),
  domicilios bigint,
  moradores bigint,
  nm_categor character varying(50),
  nm_localid character varying(60),
  cd_uf character varying(2),
  uf character varying(2),
  nm_uf character varying(26),
  CONSTRAINT localidades_areas_2010_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX localidades_areas_2010_geom_gist
  ON localidades_areas_2010
  USING gist
  (geom );
CREATE INDEX localidades_areas_2010_geomproj_gist
  ON localidades_areas_2010
  USING gist
  (geomproj );
--
-- Cria Tabela localidades_areas_2010_piabanha
--
CREATE TABLE localidades_areas_2010_piabanha
(
  gid integer NOT NULL,
  id_nucleo integer,
  id_localidade integer,
  geom geometry(Polygon,4326),
  geomproj geometry(Polygon,32723),
  cd_geocodd character varying(20),
  nm_distrit character varying(60),
  cd_geocodm character varying(20),
  nm_municip character varying(60),
  domicilios bigint,
  moradores bigint,
  nm_categor character varying(50),
  nm_localid character varying(60),
  cd_uf character varying(2),
  uf character varying(2),
  nm_uf character varying(26),
  CONSTRAINT localidades_areas_2010_piabanha_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX localidades_areas_2010_piabanha_geom_gist
  ON localidades_areas_2010_piabanha
  USING gist
  (geom );
CREATE INDEX localidades_areas_2010_piabanha_geomproj_gist
  ON localidades_areas_2010_piabanha
  USING gist
  (geomproj );
--
-- Cria Tabela mapa_acum_trecho
--
CREATE TABLE mapa_acum_trecho
(
  gid_tr integer,
  car integer,
  valacum double precision
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela mapa_trecho
--
CREATE TABLE mapa_trecho
(
  gid_tr integer,
  car integer,
  valor double precision
)
WITH (
  OIDS=FALSE
);
CREATE INDEX mapa_trecho_gid_tr_btree
  ON mapa_trecho
  USING btree
  (gid_tr );
--
-- Cria Tabela municipios_a_excluir
--
CREATE TABLE municipios_a_excluir
(
  gid serial NOT NULL,
  cd_geocodm character varying(20),
  nm_municip character varying(60),
  CONSTRAINT municipios_a_excluir_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela set_cens_area_contrib
--
CREATE TABLE set_cens_area_contrib
(
  gid serial NOT NULL,
  gid_tr integer,
  gid_set_desag integer,
  gid_set_agr integer,
  geomproj geometry,
  area double precision,
  parte double precision,
  CONSTRAINT set_cens_area_contrib_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX set_cens_area_contrib_gid_set_agr_btree
  ON set_cens_area_contrib
  USING btree
  (gid_set_agr );
--
-- Cria Tabela set_cens_piabanha
--
CREATE TABLE set_cens_piabanha
(
  gid_set_agr integer,
  gid serial NOT NULL,
  cod_setor character varying(20),
  CONSTRAINT set_cens_piabanha_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela set_cens_rj_desagr
--
CREATE TABLE set_cens_rj_desagr
(
  gid serial NOT NULL,
  gid_agr integer,
  cd_geocodi character varying(20),
  geom_uni geometry(Polygon,4326),
  geomproj_uni geometry(Polygon,32723),
  CONSTRAINT set_cens_rj_desagr_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX set_cens_rj_desagr_geom_uni_gist
  ON set_cens_rj_desagr
  USING gist
  (geom_uni );
CREATE INDEX set_cens_rj_desagr_geomproj_uni_gist
  ON set_cens_rj_desagr
  USING gist
  (geomproj_uni );
CREATE INDEX set_cens_rj_desagr_gid_agr_btree
  ON set_cens_rj_desagr
  USING btree
  (gid_agr );
--
-- Cria Tabela setores_censitarios
--
CREATE TABLE setores_censitarios
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
  CONSTRAINT setores_censitarios_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX setores_censitarios_geom_gist
  ON setores_censitarios
  USING gist
  (geom );
--
-- Cria Tabela setores_censitarios_piabanha
--
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
--
-- Cria Tabela usinas
--
CREATE TABLE usinas
(
  num integer NOT NULL,
  nome character varying(254),
  nome_alt character varying(254),
  tipo_aprov character varying(10),
  estagio_imp character varying(50),
  pot_outorgada double precision,
  pot_fiscalizada double precision,
  latitude double precision,
  longitude double precision,
  cod_mun_1 character varying(10),
  nome_mun_1 character varying(254),
  uf_1 character varying(10),
  reg_geog_1 character varying(50),
  cod_mun_2 character varying(10),
  nome_mun_2 character varying(254),
  uf_2 character varying(10),
  reg_geog_2 character varying(50),
  nome_rio character varying(254),
  corio character varying(50),
  cocursodag character varying(50),
  cobacia character varying(50),
  dist_cdag double precision,
  dist_bac double precision,
  cobacianum bigint,
  dist_hr double precision,
  reg_hidrog character varying(50),
  cod_bac_dn integer,
  cod_sb_dn integer,
  domin_agua character varying(50),
  num_reserv integer,
  niv_jusante double precision,
  compens_fin character varying(50),
  royalty character varying(50),
  dest_energia character varying(50),
  processo_aneel character varying(254),
  ato_legal character varying(50),
  proprietario character varying(254),
  operado_ons character varying(50),
  data_inic_oper date,
  id_sgh_aneel integer,
  id_big_aneel integer,
  integra_pac character varying(50),
  camin_fich character varying(100),
  camin_imag character varying(100),
  geom geometry(Point,4326),
  geomproj geometry(Point,32723),
  geom_hr geometry(Point,4326),
  geomproj_hr geometry(Point,32723),
  num_ons integer,
  hr_dir_ind character varying(10),
  inst_out_agua character varying(50),
  tipo_out_agua character varying(20),
  ato_out_agua character varying(255),
  cotrecho integer,
  CONSTRAINT usinas_pkey PRIMARY KEY (num )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX usinas_geom_gist
  ON usinas
  USING gist
  (geom );
CREATE INDEX usinas_geom_hr_gist
  ON usinas
  USING gist
  (geom_hr );
CREATE INDEX usinas_geomproj_gist
  ON usinas
  USING gist
  (geomproj );
CREATE INDEX usinas_geomproj_hr_gist
  ON usinas
  USING gist
  (geomproj_hr );
--
-- Cria Tabela uso_acum
--
CREATE TABLE uso_acum
(
  gid serial NOT NULL,
  gid_tr integer,
  id_uso integer,
  area double precision,
  CONSTRAINT uso_acum_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX uso_acum_gid_tr_btree
  ON uso_acum
  USING btree
  (gid_tr );
--
-- Cria Tabela uso_acum_exp
--
CREATE TABLE uso_acum_exp
(
  cotrecho integer,
  id_uso integer,
  uso character varying(50),
  area_km2 double precision
)
WITH (
  OIDS=FALSE
);
CREATE INDEX uso_acum_exp_cotrecho_btree
  ON uso_acum_exp
  USING btree
  (cotrecho );
--
-- Cria Tabela uso_area_contrib
--
CREATE TABLE uso_area_contrib
(
  gid serial NOT NULL,
  gid_tr integer,
  id_uso integer,
  geomproj geometry,
  area double precision,
  CONSTRAINT uso_area_contrib_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela uso_cobertura
--
CREATE TABLE uso_cobertura
(
  gid serial NOT NULL,
  uso character varying(50),
  area_alber numeric,
  hectares_a numeric,
  geom geometry(MultiPolygon,4326),
  id_uso integer,
  geom_uni geometry(Polygon,4326),
  geomproj_uni geometry(Polygon,32723),
  CONSTRAINT uso_cobertura_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX uso_cobertura_geom_gist
  ON uso_cobertura
  USING gist
  (geom );
--
-- Cria Tabela uso_desagregada
--
CREATE TABLE uso_desagregada
(
  gid serial NOT NULL,
  gid_orig integer,
  id_uso integer,
  uso character varying(50),
  geom geometry(Polygon,4326),
  geomproj geometry(Polygon,32723),
  CONSTRAINT uso_desagregada_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX uso_desagregada_geomproj_gist
  ON uso_desagregada
  USING gist
  (geomproj );
--
-- Cria Tabela usos
--
CREATE TABLE usos
(
  id_uso serial NOT NULL,
  uso character varying(50),
  CONSTRAINT usos_pkey PRIMARY KEY (id_uso )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela var_censit_acum
--
CREATE TABLE var_censit_acum
(
  gid_tr integer,
  id_var_censit integer,
  valacum double precision
)
WITH (
  OIDS=FALSE
);
CREATE INDEX var_censit_acum_gid_tr_btree
  ON var_censit_acum
  USING btree
  (gid_tr );
--
-- Cria Tabela var_censit_acum_exp
--
CREATE TABLE var_censit_acum_exp
(
  cotrecho integer,
  id_var_censit integer,
  descricao text,
  valor double precision
)
WITH (
  OIDS=FALSE
);
CREATE INDEX var_censit_acum_exp_cotrecho_btree
  ON var_censit_acum_exp
  USING btree
  (cotrecho );
--
-- Cria Tabela var_censit_piabanha
--
CREATE TABLE var_censit_piabanha
(
  gid serial NOT NULL,
  gid_set_agr integer,
  id_var integer,
  valor double precision,
  CONSTRAINT var_censit_piabanha_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela variaveis_censitarias
--
CREATE TABLE variaveis_censitarias
(
  id_var_censit integer NOT NULL,
  tabela character varying(50),
  variavel character varying(50),
  descricao text,
  valor_bacia double precision,
  CONSTRAINT variaveis_censitarias_pkey PRIMARY KEY (id_var_censit )
)
WITH (
  OIDS=FALSE
);
