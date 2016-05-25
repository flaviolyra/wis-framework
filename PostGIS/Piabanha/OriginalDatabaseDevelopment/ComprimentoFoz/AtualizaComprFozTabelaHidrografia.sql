UPDATE hidrografia SET compr_foz = c.compr
FROM compr_foz AS c
WHERE hidrografia.gid = c.gid