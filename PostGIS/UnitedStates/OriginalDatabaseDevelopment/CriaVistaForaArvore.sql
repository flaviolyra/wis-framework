CREATE VIEW fora_arvore AS
SELECT comid from nhdv2_attributes.plusflowlinevaa WHERE comid NOT IN (SELECT comid FROM arvore_areas)