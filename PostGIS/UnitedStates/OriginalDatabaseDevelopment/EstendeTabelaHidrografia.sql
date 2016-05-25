ALTER TABLE hidrografia ADD fcode integer;
ALTER TABLE hidrografia ADD gnis_id character varying(10);
ALTER TABLE hidrografia ADD gnis_name character varying(65);
ALTER TABLE hidrografia ADD pathlength double precision;
ALTER TABLE hidrografia ADD reachcode character varying(14);
UPDATE hidrografia SET fcode = n.fcode
FROM nhdv2_nhd.nhdflowline AS n
WHERE hidrografia.comid = n.comid;
UPDATE hidrografia SET gnis_id = n.gnis_id
FROM nhdv2_nhd.nhdflowline AS n
WHERE hidrografia.comid = n.comid;
UPDATE hidrografia SET gnis_name = n.gnis_name
FROM nhdv2_nhd.nhdflowline AS n
WHERE hidrografia.comid = n.comid;
UPDATE hidrografia SET pathlength = pfv.pathlength
FROM nhdv2_attributes.plusflowlinevaa AS pfv
WHERE hidrografia.comid = pfv.comid;
UPDATE hidrografia SET reachcode = n.reachcode
FROM nhdv2_nhd.nhdflowline AS n
WHERE hidrografia.comid = n.comid;
