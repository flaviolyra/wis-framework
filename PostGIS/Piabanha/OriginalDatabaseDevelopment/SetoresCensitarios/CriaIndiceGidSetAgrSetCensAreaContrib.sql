CREATE INDEX set_cens_area_contrib_gid_set_agr_btree
  ON set_cens_area_contrib
  USING btree
  (gid_set_agr );
