CREATE OR REPLACE FUNCTION gera_tabela_topologica(tipo character varying(30), cotrecho integer, cobacia character varying(30), dist double precision)
 RETURNS integer AS $$
DECLARE
  nome_schema text;
  nome_tabela text;
  string_sql text;
BEGIN
  BEGIN
    SELECT schema_name INTO STRICT nome_schema FROM information_schema.schemata WHERE schema_name = 'montante_jusante';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CREATE SCHEMA montante_jusante;
  END;
  BEGIN
    SELECT table_name INTO STRICT nome_tabela FROM information_schema.tables WHERE table_schema='montante_jusante' AND table_name = tipo || '_' || cotrecho::text;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CASE tipo
          WHEN 'area_mont' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM area_contrib AS a INNER JOIN (SELECT tr_md(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ') AS tr) AS tm ON a.cotrecho = tm.tr';
          WHEN 'trecho_mont' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT tr_md(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ') AS tr) AS tm ON a.cotrecho = tm.tr';
          WHEN 'curso_princ_jus' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT tr_jd(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ') AS tr) AS tj ON a.cotrecho = tj.tr';
          WHEN 'curso_total_jus' THEN
            string_sql := 'CREATE TABLE montante_jusante.' || tipo || '_' || cotrecho::text ||
              ' AS SELECT * FROM hidrografia AS a INNER JOIN (SELECT unnest(tr_jdt(''' || cobacia || ''', ' ||
              replace(btrim(to_char(dist, '99999D999999')), ',', '.') || ', ''{}'', TRUE)) AS tr) AS tj ON a.cotrecho = tj.tr';
          ELSE
            RETURN 1;
        END CASE;
        EXECUTE string_sql;
  END;
  RETURN 0;
END;
$$ LANGUAGE plpgsql;
