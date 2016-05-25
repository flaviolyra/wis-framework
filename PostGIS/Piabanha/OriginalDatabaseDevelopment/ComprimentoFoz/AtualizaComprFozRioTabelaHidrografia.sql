UPDATE hidrografia SET compr_foz_rio = hidrografia.compr_foz - n.compr_foz
FROM nomes_rios_ordenados AS n
WHERE hidrografia.corio = n.corio