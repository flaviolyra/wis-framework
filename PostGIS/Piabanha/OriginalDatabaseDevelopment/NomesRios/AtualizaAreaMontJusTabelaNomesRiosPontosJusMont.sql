UPDATE nomes_rios_pontos_jus_mont SET area_mont_jus = h.area_mont
FROM hidrografia AS h WHERE h.cobacia = nomes_rios_pontos_jus_mont.cobac_jus