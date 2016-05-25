UPDATE hidrografia SET corio = r.corio
FROM rios AS r
WHERE hidrografia.gnis_id = r.gnis_id