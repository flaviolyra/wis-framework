INSERT INTO area_contrib (cotrecho, gridcode, sourcefc, areasqkm, geom)
SELECT featureid, gridcode, sourcefc, areasqkm, geom FROM nhdv2_catchments.catchment;
