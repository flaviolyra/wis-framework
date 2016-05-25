DELETE FROM hidrografia
WHERE gid IN
(SELECT gid FROM trechos_finais_curtos)