ALTER TABLE nos_trechos_4_conexoes ALTER ordem_afl TYPE integer;
UPDATE nos_trechos_4_conexoes SET ordem_afl = ordem_afl - om.ordem_mont + 1
FROM
(SELECT DISTINCT ON (no_term) no_term, ordem_afl AS ordem_mont
FROM nos_trechos_4_conexoes
ORDER BY no_term, compracum DESC) AS om
WHERE nos_trechos_4_conexoes.no_term = om.no_term;
