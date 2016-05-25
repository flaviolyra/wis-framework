CREATE VIEW intersecoes_sem_nos AS 
 SELECT h1.gid AS id1, h1.no_de AS node1, h1.no_para AS nopara1,
        st_line_locate_point(h1.geomproj_uni, st_intersection(h1.geomproj_uni, h2.geomproj_uni)) AS local1,
        h1.geomproj_uni AS geom_l1, h1.nome_dre AS nome_dre_l1,
        st_intersection(h1.geomproj_uni, h2.geomproj_uni) AS geom_int,
        h2.gid AS id2, h2.no_de AS node2, h2.no_para AS nopara2,
        st_line_locate_point(h2.geomproj_uni, st_intersection(h1.geomproj_uni, h2.geomproj_uni)) AS local2
   FROM hidrografia h1
   JOIN hidrografia h2 ON st_intersects(h1.geomproj_uni, h2.geomproj_uni)
                          AND h1.gid <> h2.gid
                          AND NOT (h1.no_de = h2.no_de OR h1.no_de = h2.no_para OR h1.no_para = h2.no_de OR h1.no_para = h2.no_para);
