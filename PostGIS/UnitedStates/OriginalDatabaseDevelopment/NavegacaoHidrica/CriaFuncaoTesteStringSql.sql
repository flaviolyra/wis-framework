CREATE OR REPLACE FUNCTION teste(tipo character varying(30), cotrecho integer, cobacia character varying(30), dist double precision)
  RETURNS text AS $$
DECLARE
  string_sql text;
BEGIN
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
  RETURN string_sql;
END;
$$ LANGUAGE plpgsql;
