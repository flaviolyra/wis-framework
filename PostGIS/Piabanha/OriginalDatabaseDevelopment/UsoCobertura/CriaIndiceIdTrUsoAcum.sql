CREATE INDEX uso_acum_gid_tr_btree
  ON uso_acum
  USING btree
  (gid_tr );