CREATE INDEX nos_geomproj_gist
  ON nos
  USING gist
  (geomproj );
