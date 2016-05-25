INSERT INTO rios  (cocursodag, pathlength, gnis_id, gnis_name)
SELECT cocursodag, pathlength, gnis_id, gnis_name FROM
(SELECT DISTINCT ON (gnis_id) gnis_id, gnis_name, cocursodag, pathlength FROM hidrografia ORDER BY gnis_id, pathlength) AS rios
ORDER BY cocursodag, pathlength