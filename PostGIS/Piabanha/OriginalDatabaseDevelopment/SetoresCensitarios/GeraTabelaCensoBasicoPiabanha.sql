INSERT INTO censo_basico_piabanha
SELECT sp.gid_set_agr, c.cod_setor, c.cod_grande_regiao, c.nome_grande_regiao, c.cod_uf, c.nome_uf, c.cod_meso, c.nome_meso, c.cod_micro, c.nome_micro,
  c.cod_rm, c.nome_rm, c.cod_municipio, c.nome_municipio, c.cod_distrito, c.nome_distrito, c.cod_subdistrito, c.nome_subdistrito, c.cod_bairro,
  c.nome_bairro, c.situacao_setor, c.v001, c.v002, c.v003, c.v004, c.v005, c.v006, c.v007, c.v008, c.v009, c.v010, c.v011, c.v012
FROM set_cens_piabanha AS sp INNER JOIN censo_basico AS c ON c.cod_setor = sp.cod_setor