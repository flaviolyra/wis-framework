INSERT INTO nomes_cursos_rios_jusante_total (gid_rio, nome_dre, cobac_jus, cocurs_jus, area_mont_jus, cobac_mont, cocurs_mont, area_mont_mont, nome_dre_curso,
  cobacia, cocursodag, area_mont, fase_id_nomes)
  SELECT gid_rio, nome_dre, cobac_jus, cocurs_jus, area_mont_jus, cobac_mont, cocurs_mont, area_mont_mont, nome_dre AS nome_dre_curso,
  cobac_mont AS cobacia, cocurs_mont AS cocursodag, area_mont_mont AS area_mont, fase_id_nomes FROM nomes_rios_pontos_jus_mont ORDER BY gid_rio