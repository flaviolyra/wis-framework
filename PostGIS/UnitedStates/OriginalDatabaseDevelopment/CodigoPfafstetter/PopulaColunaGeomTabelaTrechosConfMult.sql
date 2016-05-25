UPDATE trechos_conf_mult SET geom = h.geom
FROM hidrografia AS h
WHERE trechos_conf_mult.comid = h.comid