-- Apaga conteúdo de liinhas_a_fundir
DELETE FROM linhas_a_fundir;
-- insere linhas normais em linhas_a_fundir
INSERT INTO linhas_a_fundir
(id_curta, no_de_curta, no_para_curta, ponto_uniao_curta, compr_curta,
id_outra, no_de_outra, no_para_outra, ponto_uniao_outra, compr_outra)
SELECT DISTINCT ON (id_outra)
id_curta, no_de_curta, no_para_curta, ponto_uniao_curta, compr_curta,
id_outra, no_de_outra, no_para_outra, ponto_uniao_outra, compr_outra
FROM linhas_normais_a_fundir
WHERE compr_curta < compr_outra;
-- Elimina duplicações de linhas_a_fundir
DELETE FROM linhas_a_fundir
WHERE id_curta IN
(SELECT DISTINCT id_outra FROM linhas_a_fundir);
-- atualiza geometria de linha curta
UPDATE linhas_a_fundir SET geom_curta = hidrografia.geomproj_uni
FROM hidrografia
WHERE linhas_a_fundir.id_curta = hidrografia.gid;
-- atualiza geometria da outra linha
UPDATE linhas_a_fundir SET geom_outra = hidrografia.geomproj_uni
FROM hidrografia
WHERE linhas_a_fundir.id_outra = hidrografia.gid;
-- calcula geometria da linha fusão
UPDATE linhas_a_fundir SET geom_fusao = une_linhas(geom_curta, geom_outra);
-- substitui linha outra por linha fundida
UPDATE hidrografia SET geomproj_uni = lf.geom_fusao
FROM linhas_a_fundir AS lf
WHERE hidrografia.gid = lf.id_outra;
-- apaga linha curta
DELETE FROM hidrografia
WHERE gid IN
(SELECT id_curta FROM linhas_a_fundir);