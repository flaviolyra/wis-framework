INSERT INTO nomes_rios_pontos_jus_mont (gid_rio, nome_dre, cobac_jus, cocurs_jus, area_mont_jus, cobac_mont, cocurs_mont, area_mont_mont)
SELECT DISTINCT ON (gid_rio) gid_rio, nome_dre, cobac_jus, cocurs_jus, area_mont_jus, cobacia AS cobac_mont, cocursodag as cocurs_mont,
  area_mont AS area_mont_mont FROM nomes_cursos_rios_montante ORDER BY gid_rio, area_mont