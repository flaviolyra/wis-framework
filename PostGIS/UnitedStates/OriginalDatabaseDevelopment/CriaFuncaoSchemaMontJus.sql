CREATE OR REPLACE FUNCTION schema_mont_jus() RETURNS integer AS $$
DECLARE
  nome_schema text;
BEGIN
  BEGIN
    SELECT schema_name INTO STRICT nome_schema FROM information_schema.schemata WHERE schema_name = 'montante_jusante';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CREATE SCHEMA montante_jusante;
  END;
  RETURN 0;
END;
$$ LANGUAGE plpgsql;
