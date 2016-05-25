CREATE TABLE nos_quatro_conexoes
  (gid serial NOT NULL,
   id_no integer,
   id_tr_montante integer,
   no_lig_tr_montante text,
   id_tr_jusante integer,
   no_lig_tr_jusante text,
   id_tr_afl_1 integer,
   no_lig_tr_afl_1 text,
   id_tr_afl_2 integer,
   no_lig_tr_afl_2 text,
   geom_tr_montante geometry(Linestring, 32723),
   geom_tr_jusante geometry(Linestring, 32723),
   geom_tr_afl_1 geometry(Linestring, 32723),
   geom_tr_afl_2 geometry(Linestring, 32723),
   geom_pt_confl geometry(Point, 32723),
   geom_npt_confl geometry(Point, 32723),
   geom_ntr_lig geometry(Linestring, 32723),
   geom_ntr_montante geometry(Linestring, 32723),
   geom_ntr_afl_1 geometry(Linestring, 32723),
   geom_ntr_afl_2 geometry(Linestring, 32723),
   CONSTRAINT nos_quatro_conexoes_pkey PRIMARY KEY (gid)
  )
WITH (OIDS=FALSE);