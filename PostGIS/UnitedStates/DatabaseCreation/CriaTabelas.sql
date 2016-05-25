--
-- Cria Schema hydro1k
--
CREATE SCHEMA hydro1k AUTHORIZATION postgres;
--
-- Cria Tabela hydro1k
--
CREATE TABLE hydro1k.bacias_h1k
(
  gid serial NOT NULL,
  userid numeric(10,0),
  fnode_ numeric(10,0),
  tnode_ numeric(10,0),
  lpoly_ numeric(10,0),
  rpoly_ numeric(10,0),
  geomproj geometry(MultiLineString,2163)
)
WITH (
  OIDS=FALSE
);
CREATE INDEX bacias_h1k_geomproj_gist
  ON hydro1k.bacias_h1k
  USING gist
  (geomproj );
--
-- Cria Tabela rios_h1k
--
CREATE TABLE hydro1k.rios_h1k
(
  gid serial NOT NULL,
  userid numeric(10,0),
  fnode_ numeric(10,0),
  tnode_ numeric(10,0),
  lpoly_ numeric(10,0),
  rpoly_ numeric(10,0),
  length double precision,
  "na_str#" integer,
  "na_str-id" integer,
  flowacc integer,
  pf_type smallint,
  level1 integer,
  level2 integer,
  level3 integer,
  level4 integer,
  level5 integer,
  level6 integer,
  frmelevati integer,
  toelevatio integer,
  strorder smallint,
  gradient double precision,
  frmup_flow double precision,
  toup_flowl double precision,
  frmdn_flow double precision,
  todn_flowl double precision,
  geomproj geometry(MultiLineString,2163)
)
WITH (
  OIDS=FALSE
);
CREATE INDEX rios_h1k_geomproj_gist
  ON hydro1k.rios_h1k
  USING gist
  (geomproj );
--
-- Cria Schema nhdv2_attributes
--
CREATE SCHEMA nhdv2_attributes AUTHORIZATION postgres;
--
-- Cria Tabela cumulativearea
--
CREATE TABLE nhdv2_attributes.cumulativearea
(
  gid serial NOT NULL,
  comid integer,
  totdasqkm double precision,
  divdasqkm double precision
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela divfracmp
--
CREATE TABLE nhdv2_attributes.divfracmp
(
  gid serial NOT NULL,
  nodenumber integer,
  comid integer,
  statusflag character varying(1),
  divfrac double precision,
  CONSTRAINT divfracmp_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela elevslope
--
CREATE TABLE nhdv2_attributes.elevslope
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  maxelevraw double precision,
  minelevraw double precision,
  maxelevsmo double precision,
  minelevsmo double precision,
  slope double precision,
  elevfixed character varying(1),
  hwtype character varying(1),
  statusflag character varying(1),
  slopelenkm double precision
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela headwaternodearea
--
CREATE TABLE nhdv2_attributes.headwaternodearea
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  hwnodesqkm numeric
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela megadiv
--
CREATE TABLE nhdv2_attributes.megadiv
(
  gid serial NOT NULL,
  fromcomid integer,
  tocomid integer
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela plusarpointevent
--
CREATE TABLE nhdv2_attributes.plusarpointevent
(
  gid serial NOT NULL,
  comid integer,
  eventdate date,
  reachcode character varying(14),
  reachsmdat date,
  reachresol character varying(7),
  featurecom integer,
  featurecla character varying(15),
  source_ori character varying(130),
  source_dat character varying(100),
  source_fea character varying(40),
  featuredet character varying(254),
  measure numeric,
  "offset" numeric,
  eventtype character varying(100),
  CONSTRAINT plusarpointevent_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela plusflow
--
CREATE TABLE nhdv2_attributes.plusflow
(
  gid serial NOT NULL,
  fromcomid integer,
  fromhydseq double precision,
  fromlvlpat double precision,
  tocomid integer,
  tohydseq double precision,
  tolvlpat double precision,
  nodenumber double precision,
  deltalevel smallint,
  direction smallint,
  gapdistkm double precision,
  hasgeo character varying(1),
  totdasqkm double precision,
  divdasqkm double precision
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela plusflowar
--
CREATE TABLE nhdv2_attributes.plusflowar
(
  gid serial NOT NULL,
  fromcomid integer,
  fromfc character varying(20),
  tocomid integer,
  tofc character varying(20),
  quantity double precision,
  units character varying(10),
  CONSTRAINT plusflowar_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela plusflowlinevaa
--
CREATE TABLE nhdv2_attributes.plusflowlinevaa
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  streamleve integer,
  streamorde integer,
  streamcalc integer,
  fromnode integer,
  tonode integer,
  hydroseq integer,
  levelpathi integer,
  pathlength double precision,
  terminalpa integer,
  arbolatesu double precision,
  divergence integer,
  startflag integer,
  terminalfl integer,
  dnlevel integer,
  thinnercod integer,
  uplevelpat integer,
  uphydroseq integer,
  dnlevelpat integer,
  dnminorhyd integer,
  dndraincou integer,
  dnhydroseq integer,
  frommeas double precision,
  tomeas double precision,
  reachcode character varying(14),
  lengthkm double precision,
  fcode integer,
  rtndiv integer,
  outdiv integer,
  diveffect integer,
  vpuin integer,
  vpuout integer,
  travtime double precision,
  pathtime double precision,
  areasqkm double precision,
  totdasqkm double precision,
  divdasqkm double precision,
  CONSTRAINT plusflowlinevaa_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Schema nhdv2_catchments
--
CREATE SCHEMA nhdv2_catchments AUTHORIZATION postgres;
--
-- Cria Tabela catchment
--
CREATE TABLE nhdv2_catchments.catchment
(
  gid serial NOT NULL,
  gridcode integer,
  featureid integer,
  sourcefc character varying(20),
  areasqkm numeric,
  geom geometry(MultiPolygon,4269),
  CONSTRAINT catchment_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX catchment_geom_gist
  ON nhdv2_catchments.catchment
  USING gist
  (geom );
--
-- Cria Tabela featureidgridcode
--
CREATE TABLE nhdv2_catchments.featureidgridcode
(
  gid serial NOT NULL,
  featureid integer,
  gridcode integer,
  sourcefc character varying(20),
  rpuid character varying(8),
  CONSTRAINT featureidgridcode_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Schema nhdv2_globaldata
--
CREATE SCHEMA nhdv2_globaldata AUTHORIZATION postgres;
--
-- Cria Tabela boundaryunit
--
CREATE TABLE nhdv2_globaldata.boundaryunit
(
  gid serial NOT NULL,
  drainageid character varying(2),
  unitid character varying(8),
  unitname character varying(100),
  unittype character varying(5),
  hydroseq numeric,
  areasqkm numeric,
  shape_leng numeric,
  shape_area numeric,
  geom geometry(MultiPolygon,4269),
  CONSTRAINT boundaryunit_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX boundaryunit_geom_gist
  ON nhdv2_globaldata.boundaryunit
  USING gist
  (geom );
--
-- Cria Tabela supercatchments
--
CREATE TABLE nhdv2_globaldata.supercatchments
(
  gid serial NOT NULL,
  gridcode numeric(10,0),
  featureid integer,
  sourcefc character varying(20),
  areasqkm numeric,
  vpuid character varying(8),
  geom geometry(MultiPolygonZM,4269),
  CONSTRAINT supercatchments_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX supercatchments_geom_gist
  ON nhdv2_globaldata.supercatchments
  USING gist
  (geom );
--
-- Cria Schema nhdv2_nhd
--
CREATE SCHEMA nhdv2_nhd AUTHORIZATION postgres;
--
-- Cria Tabela nhdarea
--
CREATE TABLE nhdv2_nhd.nhdarea
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  resolution character varying(7),
  gnis_id character varying(10),
  gnis_name character varying(65),
  areasqkm numeric,
  elevation numeric,
  ftype character varying(24),
  fcode integer,
  shape_leng numeric,
  shape_area numeric,
  geom geometry(MultiPolygonZM,4269),
  CONSTRAINT nhdarea_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdarea_geom_gist
  ON nhdv2_nhd.nhdarea
  USING gist
  (geom );
--
-- Cria Tabela nhdareaeventfc
--
CREATE TABLE nhdv2_nhd.nhdareaeventfc
(
  gid serial NOT NULL,
  comid integer,
  eventdate date,
  reachcode character varying(14),
  reachsmdat date,
  reachresol character varying(7),
  featurecom integer,
  featurecla character varying(15),
  source_ori character varying(130),
  source_dat character varying(100),
  source_fea character varying(40),
  featuredet character varying(254),
  eventtype character varying(100),
  shape_leng numeric,
  shape_area numeric,
  geom geometry(MultiPolygon,4269),
  CONSTRAINT nhdareaeventfc_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdareaeventfc_geom_gist
  ON nhdv2_nhd.nhdareaeventfc
  USING gist
  (geom );
--
-- Cria Tabela nhdfcode
--
CREATE TABLE nhdv2_nhd.nhdfcode
(
  gid serial NOT NULL,
  fcode integer,
  descriptio character varying(254),
  canalditch character varying(32),
  constructi character varying(32),
  hydrograph character varying(32),
  inundation character varying(32),
  operationa character varying(32),
  pipelinety character varying(32),
  positional character varying(32),
  relationsh character varying(32),
  reservoirt character varying(32),
  stage character varying(32),
  specialuse character varying(32),
  CONSTRAINT nhdfcode_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela nhdflowline
--
CREATE TABLE nhdv2_nhd.nhdflowline
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  resolution character varying(7),
  gnis_id character varying(10),
  gnis_name character varying(65),
  lengthkm numeric,
  reachcode character varying(14),
  flowdir character varying(15),
  wbareacomi integer,
  ftype character varying(24),
  fcode integer,
  shape_leng numeric,
  enabled character varying(6),
  gnis_nbr integer,
  geom geometry(MultiLineStringZM,4269),
  CONSTRAINT nhdflowline_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdflowline_geom_gist
  ON nhdv2_nhd.nhdflowline
  USING gist
  (geom );
--
-- Cria Tabela nhdline
--
CREATE TABLE nhdv2_nhd.nhdline
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  resolution character varying(7),
  gnis_id character varying(10),
  gnis_name character varying(65),
  lengthkm numeric,
  ftype character varying(24),
  fcode integer,
  shape_leng numeric,
  geom geometry(MultiLineStringZM,4269),
  CONSTRAINT nhdline_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdline_geom_gist
  ON nhdv2_nhd.nhdline
  USING gist
  (geom );
--
-- Cria Tabela nhdlineeventfc
--
CREATE TABLE nhdv2_nhd.nhdlineeventfc
(
  gid serial NOT NULL,
  comid integer,
  eventdate date,
  reachcode character varying(14),
  reachsmdat date,
  reachresol character varying(7),
  featurecom integer,
  featurecla character varying(15),
  source_ori character varying(130),
  source_dat character varying(100),
  source_fea character varying(40),
  featuredet character varying(254),
  fmeasure numeric,
  tmeasure numeric,
  eventtype character varying(100),
  "offset" numeric,
  shape_leng numeric,
  geom geometry(MultiLineString,4269),
  CONSTRAINT nhdlineeventfc_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdlineeventfc_geom_gist
  ON nhdv2_nhd.nhdlineeventfc
  USING gist
  (geom );
--
-- Cria Tabela nhdpoint
--
CREATE TABLE nhdv2_nhd.nhdpoint
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  resolution character varying(7),
  gnis_id character varying(10),
  gnis_name character varying(65),
  reachcode character varying(14),
  ftype character varying(24),
  fcode integer,
  geom geometry(PointZM,4269),
  CONSTRAINT nhdpoint_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdpoint_geom_gist
  ON nhdv2_nhd.nhdpoint
  USING gist
  (geom );
--
-- Cria Tabela nhdpointeventfc
--
CREATE TABLE nhdv2_nhd.nhdpointeventfc
(
  gid serial NOT NULL,
  comid integer,
  eventdate date,
  reachcode character varying(14),
  reachsmdat date,
  reachresol character varying(7),
  featurecom integer,
  featurecla character varying(15),
  source_ori character varying(130),
  source_dat character varying(100),
  source_fea character varying(40),
  featuredet character varying(254),
  measure numeric,
  "offset" numeric,
  eventtype character varying(100),
  geom geometry(Point,4269),
  CONSTRAINT nhdpointeventfc_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdpointeventfc_geom_gist
  ON nhdv2_nhd.nhdpointeventfc
  USING gist
  (geom );
--
-- Cria Tabela nhdreachcode_comid
--
CREATE TABLE nhdv2_nhd.nhdreachcode_comid
(
  gid serial NOT NULL,
  comid integer,
  reachcode character varying(14),
  reachsmdat date,
  resolution character varying(7),
  gnis_id character varying(10),
  gnis_name character varying(100),
  CONSTRAINT nhdreachcode_comid_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela nhdreachcrossreference
--
CREATE TABLE nhdv2_nhd.nhdreachcrossreference
(
  gid serial NOT NULL,
  oldreachco character varying(17),
  oldreachda date,
  newreachco character varying(17),
  newreachda date,
  oldupmi character varying(5),
  newupmi character varying(5),
  changecode character varying(4),
  process character varying(6),
  reachfilev character varying(10),
  oldhucode character varying(8),
  newhucode character varying(8),
  CONSTRAINT nhdreachcrossreference_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
--
-- Cria Tabela nhdwaterbody
--
CREATE TABLE nhdv2_nhd.nhdwaterbody
(
  gid serial NOT NULL,
  comid integer,
  fdate date,
  resolution character varying(7),
  gnis_id character varying(10),
  gnis_name character varying(65),
  areasqkm numeric,
  elevation numeric,
  reachcode character varying(14),
  ftype character varying(24),
  fcode integer,
  shape_leng numeric,
  shape_area numeric,
  geom geometry(MultiPolygonZM,4269),
  CONSTRAINT nhdwaterbody_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX nhdwaterbody_geom_gist
  ON nhdv2_nhd.nhdwaterbody
  USING gist
  (geom );
--
-- Cria Tabela area_contrib
--
CREATE TABLE area_contrib
(
  gid serial NOT NULL,
  cotrecho integer,
  gridcode integer,
  sourcefc character varying(20),
  areasqkm double precision,
  geom geometry(MultiPolygon,4269),
  geomproj geometry(MultiPolygon,5070),
  CONSTRAINT area_contrib_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX area_contrib_cotrecho_btree
  ON area_contrib
  USING btree
  (cotrecho );
CREATE INDEX area_contrib_geom_gist
  ON area_contrib
  USING gist
  (geom );
CREATE INDEX area_contrib_geomproj_gist
  ON area_contrib
  USING gist
  (geomproj );
--
-- Cria Tabela arvore_areas
--
CREATE TABLE arvore_areas
(
  gid serial NOT NULL,
  comid integer,
  fromnode integer,
  tonode integer,
  lengthkm double precision,
  areasqkm double precision,
  cumareasqkm double precision,
  CONSTRAINT arvore_areas_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
CREATE INDEX arvore_areas_comid_btree
  ON arvore_areas
  USING btree
  (comid );
--
-- Cria Tabela divergencias
--
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
--
-- Cria Tabela folhas_milionesimo
--
CREATE TABLE folhas_milionesimo
(
  gid serial NOT NULL,
  codigo character varying(10),
  nome character varying(20),
  xmn double precision,
  ymn double precision,
  xmx double precision,
  ymx double precision,
  geom geometry(Polygon,4326),
  CONSTRAINT folhas_milionesimo_pkey PRIMARY KEY (gid )
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
  cotrecho integer,
  fromnode integer,
  tonode integer,
  divergence integer,
  lengthkm double precision,
  areasqkm double precision,
  ftype character varying(24),
  fcode integer,
  gnis_id character varying(10),
  noriocomp character varying(65),
  cobacia character varying(30),
  cocursodag character varying(30),
  corio character varying(30),
  cobacianum bigint,
  nudistbact double precision,
  nudistbacr double precision,
  nuareamont double precision,
  geom geometry(MultiLineStringZM,4269),
  geomproj geometry(MultiLineStringZM,5070),
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
CREATE INDEX hidrografia_tonode_btree
  ON hidrografia
  USING btree
  (tonode );
--
-- Cria Tabela rios
--
CREATE TABLE rios
(
  gid serial NOT NULL,
  gid0 integer,
  corio character varying(30),
  cocursodag character varying(30),
  pathlength double precision,
  gnis_id character varying(10),
  gnis_name character varying(65),
  CONSTRAINT rios_pkey PRIMARY KEY (gid )
)
WITH (
  OIDS=FALSE
);
