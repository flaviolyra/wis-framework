DROP INDEX hidrografia_fromnode_btree;
DROP INDEX hidrografia_tonode_btree;
ALTER TABLE hidrografia DROP CONSTRAINT hidrografia_pkey;
ALTER TABLE hidrografia RENAME TO hidrografia_orig;
