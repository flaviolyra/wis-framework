UPDATE set_cens_piabanha SET cod_setor = sc.cd_geocodi
FROM setores_censitarios AS sc
WHERE sc.gid = set_cens_piabanha.gid_set_agr