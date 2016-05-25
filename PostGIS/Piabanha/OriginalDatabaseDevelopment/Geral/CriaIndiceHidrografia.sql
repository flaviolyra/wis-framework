CREATE INDEX hidrografia_geomproj_uni_gist
  ON hidrografia
  USING gist
  (geomproj_uni );
