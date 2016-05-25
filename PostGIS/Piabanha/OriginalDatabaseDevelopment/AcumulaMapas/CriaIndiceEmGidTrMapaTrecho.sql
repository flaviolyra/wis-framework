CREATE INDEX mapa_trecho_gid_tr_btree
  ON mapa_trecho
  USING btree
  (gid_tr );
