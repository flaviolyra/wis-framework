UPDATE nomes_rios_ordenados SET compr_foz = h.compr_foz
FROM hidrografia AS h
WHERE nomes_rios_ordenados.cobacia = h.cobacia