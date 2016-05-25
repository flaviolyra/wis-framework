CREATE INDEX set_cens_rj_desagr_gid_agr_btree
  ON set_cens_rj_desagr
  USING btree
  (gid_agr );
