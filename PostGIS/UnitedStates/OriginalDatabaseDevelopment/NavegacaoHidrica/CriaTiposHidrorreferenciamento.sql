CREATE TYPE bacmont AS
   (codbac character varying,
    bac geometry);
CREATE TYPE limjus AS
   (crpagua text,
    cdbacmont bigint);
CREATE TYPE limmont AS
   (cdbacmont bigint,
    cdbacjus bigint);