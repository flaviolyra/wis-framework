UPDATE hidrografia SET ftype = fl.ftype
FROM nhdv2_nhd.nhdflowline as fl
WHERE hidrografia.comid = fl.comid