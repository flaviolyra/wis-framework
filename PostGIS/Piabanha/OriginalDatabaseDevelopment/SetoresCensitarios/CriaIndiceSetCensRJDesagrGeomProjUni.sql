CREATE INDEX set_cens_rj_desagr_geomproj_uni_gist
  ON set_cens_rj_desagr
  USING gist
  (geomproj_uni );