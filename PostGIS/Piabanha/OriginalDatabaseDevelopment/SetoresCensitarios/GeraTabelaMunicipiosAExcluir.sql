INSERT INTO municipios_a_excluir (cd_geocodm, nm_municip)
SELECT DISTINCT cd_geocodm, nm_municip FROM setores_censitarios_piabanha