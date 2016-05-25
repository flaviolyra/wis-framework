CREATE INDEX areacontrib_9_geomproj_uni_gist
  ON areacontrib_9
  USING gist
  (geomproj_uni );
