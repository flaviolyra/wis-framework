DROP TABLE linhas_terminais_proximos;
CREATE TABLE linhas_terminais_proximos AS
SELECT * FROM linhas12_nos_terminais_proximos
WHERE compr_linha1 < compr_linha2;