SELECT ST_AsBinary((ST_Dump(ST_Polygonize(h.geomproj_uni))).geom) FROM hidrografia AS h

