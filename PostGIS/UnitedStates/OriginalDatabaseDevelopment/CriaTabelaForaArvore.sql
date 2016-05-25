CREATE TABLE fora_arvore AS
SELECT comid from nhdv2_attributes.plusflowlinevaa
EXCEPT
SELECT comid FROM arvore_areas