﻿CREATE TABLE linhas_a_fundir AS
SELECT DISTINCT ON (id_outra)
id_curta, no_de_curta, no_para_curta, ponto_uniao_curta, compr_curta,
id_outra, no_de_outra, no_para_outra, ponto_uniao_outra, compr_outra
FROM linhas_curtas_a_fundir
WHERE compr_curta < compr_outra;