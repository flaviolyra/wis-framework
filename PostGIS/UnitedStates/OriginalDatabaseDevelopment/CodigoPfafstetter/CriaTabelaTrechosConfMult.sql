CREATE TABLE trechos_conf_mult AS
SELECT comid, h.tonode, numconf FROM hidrografia AS h INNER JOIN
(SELECT tonode, numconf FROM
(SELECT tonode, count(tonode) AS numconf FROM hidrografia GROUP BY tonode) AS nc
WHERE numconf > 2
ORDER BY numconf DESC, tonode) AS conf_mult
ON h.tonode = conf_mult.tonode
ORDER BY numconf DESC, h.tonode