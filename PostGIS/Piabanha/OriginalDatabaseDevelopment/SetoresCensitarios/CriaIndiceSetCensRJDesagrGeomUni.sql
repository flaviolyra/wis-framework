CREATE INDEX set_cens_rj_desagr_geom_uni_gist
  ON set_cens_rj_desagr
  USING gist
  (geom_uni );