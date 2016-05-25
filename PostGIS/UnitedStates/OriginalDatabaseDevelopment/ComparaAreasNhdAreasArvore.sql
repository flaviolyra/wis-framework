SELECT flvaa.comid, flvaa.totdasqkm, flvaa.divdasqkm, aa.cumareasqkm
FROM nhdv2_attributes.plusflowlinevaa AS flvaa
INNER JOIN arvore_areas AS aa
ON flvaa.comid = aa.comid
ORDER BY flvaa.comid