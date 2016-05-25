CREATE INDEX uso_desagregada_geomproj_gist
  ON uso_desagregada
  USING gist
  (geomproj );
