INSERT INTO hidrografia (comid, geom)
SELECT fl.comid, fl.geom FROM nhdv2_nhd.nhdflowline AS fl INNER JOIN nhdv2_attributes.plusflowlinevaa AS flvaa ON fl.comid = flvaa.comid
