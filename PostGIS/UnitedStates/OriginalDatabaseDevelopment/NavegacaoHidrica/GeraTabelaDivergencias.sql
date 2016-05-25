INSERT INTO divergencias (nodenumber, comid, statusflag, divfrac)
SELECT nodenumber, comid, statusflag, divfrac FROM nhdv2_attributes.divfracmp
