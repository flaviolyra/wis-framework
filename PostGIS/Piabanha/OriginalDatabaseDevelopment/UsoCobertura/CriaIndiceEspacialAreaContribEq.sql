CREATE INDEX area_contrib_eq_geomproj_gist
  ON area_contrib_eq
  USING gist
  (geomproj );
