INSERT INTO trechos_acrescentar (id_folha, nome_folha, geomproj)
SELECT gid AS id_folha, 'Três Rios' AS nome_folha, geomproj
FROM folha_tresrios WHERE gid IN (1516, 886, 745, 149, 872, 1113, 1128, 355, 824, 500, 513)