CREATE OR REPLACE FUNCTION  qwerty()
RETURNS TABLE (schema name, Name name, Type char, Owner name) AS $$
SELECT n.nspname as "Schema",
  c.relname as "Name",
  CASE c.relkind WHEN 'r' THEN 'table' WHEN 'v' THEN 'view' WHEN 'm' THEN 'materialized view' WHEN 'i' THEN 'index' 
  WHEN 'S' THEN 'sequence' WHEN 's' THEN 'special' WHEN 'f' THEN 'foreign table' WHEN 'p' THEN 'table' END as "Type",
  pg_catalog.pg_get_userbyid(c.relowner) as "Owner"
FROM pg_catalog.pg_class c
     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r','p','')
      AND n.nspname <> 'pg_catalog'
      AND n.nspname <> 'information_schema'
      AND n.nspname !~ '^pg_toast'
  AND pg_catalog.pg_table_is_visible(c.oid)
ORDER BY 1,2;
$$ LANGUAGE SQL;

=====================================================================================================

get_name(tablename text)
get_table_details(tablename text)
get_index(tablename text)
get_check_constrains(tablename text)
get_rules(tablename text)
get_foreign_key(tablename text)
get_referenced(tablename text)
get_enab_triggers(tablename text)
get_dis_triggers(tablename text)


CREATE or REPLACE FUNCTION get_oid(tablename text)
RETURNS oid as $$ 
DECLARE 
output oid;
BEGIN
SELECT c.oid into output
FROM pg_catalog.pg_class c
  LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname OPERATOR(pg_catalog.~) concat('^(',tablename,')$')
  AND pg_catalog.pg_table_is_visible(c.oid);
RETURN output;
END; $$ 
LANGUAGE PLPGSQL;

=====================================================================================================

CREATE or REPLACE FUNCTION get_name(tablename text)
returns text as $$
DECLARE
output text;
BEGIN
SELECT concat('Table "',n.nspname,'.',c.relname,'"') into output
FROM pg_catalog.pg_class c
     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname OPERATOR(pg_catalog.~) concat('^(', tablename,')$');
return output;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION get_table_details(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg (dat, chr(10)) into output FROM
(SELECT rpad(colunm, MAX(LENGTH(colunm)) OVER()) || chr(9) || '|' || chr(32) 
	|| rpad(type, MAX(LENGTH(type)) OVER()) || chr(9) || '|' || chr(32) 
	|| rpad(collations, MAX(LENGTH(collations)) OVER ()) || chr(9) || '|' || chr(32)
	|| rpad(nullable, MAX(LENGTH(nullable)) OVER ()) || chr(9) || '|' || chr(32) 
	|| rpad(defaults, MAX(LENGTH(defaults)) OVER()) || chr(9) || '|' || chr(32) AS dat FROM 
	(SELECT A.attname AS colunm, 
		pg_catalog.format_type (A.atttypid, A.atttypmod) AS type, 
		COALESCE((SELECT c.collname FROM pg_catalog.pg_collation c, pg_catalog.pg_type t
   		WHERE c.oid = A.attcollation AND t.oid = A.atttypid AND A.attcollation <> t.typcollation),'') AS collations,
		CASE A.attnotnull WHEN 't' THEN 'not null' WHEN 'f' THEN 'null' END AS nullable,
		COALESCE (( SELECT SUBSTRING ( pg_catalog.pg_get_expr (d.adbin, d.adrelid) FOR 128 ) 
			FROM pg_catalog.pg_attrdef d WHERE d.adrelid = A.attrelid AND d.adnum = A.attnum AND A.atthasdef ),'') AS defaults
		FROM pg_catalog.pg_attribute A WHERE A.attrelid = get_oid(tablename) AND A.attnum > 0 AND NOT A.attisdropped ORDER BY A.attnum )T)T;
return output;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION get_index(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) FROM
(SELECT concat('"',c2.relname,'" ', pg_catalog.pg_get_constraintdef(con.oid, true),', ',
	trim(BOTH 'CREATE UNIQUE INDEX'||c2.relname||'ON '||tablename||' USING' from pg_catalog.pg_get_indexdef(i.indexrelid,0,true)))as data
FROM pg_catalog.pg_class c, pg_catalog.pg_class c2, pg_catalog.pg_index i
  LEFT JOIN pg_catalog.pg_constraint con ON (conrelid = i.indrelid AND conindid = i.indexrelid AND contype IN ('p','u','x'))
WHERE c.oid = get_oid(tablename) AND c.oid = i.indrelid AND i.indexrelid = c2.oid
ORDER BY i.indisprimary DESC, i.indisunique DESC, c2.relname) into output T;
return output;
END;
$$ LANGUAGE PLPGSQL;


CREATE or REPLACE FUNCTION get_check_constrains(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) into output FROM
(SELECT concat('"',conname,'", ',pg_catalog.pg_get_constraintdef(r.oid, true)) as data
FROM pg_catalog.pg_constraint r
WHERE r.conrelid = get_oid(tablename) AND r.contype IN('c','f')ORDER BY 1) T;
return output;
END;
$$ LANGUAGE PLPGSQL;


create or replace function get_rules(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) into output FROM
(SELECT trim(leading 'CREATE RULE' from pg_catalog.pg_get_ruledef(r.oid, true)) as data FROM pg_catalog.pg_rewrite r
WHERE r.ev_class = get_oid(tablename) ORDER BY 1) T;
return output;
END;
$$ LANGUAGE PLPGSQL;


CREATE or REPLACE FUNCTION get_foreign_key(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) into output FROM
(SELECT '"'||conname||'" '||pg_catalog.pg_get_constraintdef(r.oid, true) as data
FROM pg_catalog.pg_constraint r
WHERE r.conrelid = get_oid(tablename) AND r.contype = 'f' ORDER BY 1) T;
return output;
END;
$$ LANGUAGE PLPGSQL;


CREATE or REPLACE FUNCTION get_referenced(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) into output FROM
(SELECT concat('TABLE "',conrelid::pg_catalog.regclass,'" CONSTRAINT', '"',conname,'" ') 
|| pg_catalog.pg_get_constraintdef(c.oid, true) as data
FROM pg_catalog.pg_constraint c
WHERE c.confrelid = get_oid(tablename) AND c.contype = 'f' ORDER BY 1) T;
return output;
END;
$$ LANGUAGE PLPGSQL;


CREATE or REPLACE FUNCTION get_enab_triggers(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) into output FROM
(SELECT trim(leading 'CREATE TRIGGER' from pg_catalog.pg_get_triggerdef(t.oid, true)) as data
FROM pg_catalog.pg_trigger t WHERE t.tgrelid = get_oid(tablename) AND (not t.tgisinternal AND t.tgenabled = 'O')) T;
return output;
END;
$$ LANGUAGE PLPGSQL;

CREATE or REPLACE FUNCTION  get_dis_triggers(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data, chr(10)) into output FROM
(SELECT trim(leading 'CREATE TRIGGER' from pg_catalog.pg_get_triggerdef(t.oid, true)) as data
FROM pg_catalog.pg_trigger t WHERE t.tgrelid = get_oid(tablename) AND (not t.tgisinternal AND t.tgenabled = 'D')) T;
return output;
END;
$$ LANGUAGE PLPGSQL;;

CREATE or REPLACE FUNCTION get_relation(tablename text)
returns text as $$
DECLARE 
value text;
BEGIN
select chr(9)||chr(9)||chr(9)||chr(9)||chr(9)|| get_name(tablename)|| chr(10) || 
	get_table_details(tablename)|| chr(10) ||
	'Indexes: '||chr(10)||get_index(tablename)|| chr(10) ||
	'Check constraints: '||chr(10)||COALESCE(get_check_constrains(tablename),'')|| chr(10) ||
	'Rules: '||chr(10)||COALESCE(get_rules(tablename),'')|| chr(10) ||
	'Foreign key: '||chr(10)||COALESCE(get_foreign_key(tablename),'')|| chr(10) ||
	'Referenced by: '||chr(10)||COALESCE(get_referenced(tablename),'')|| chr(10) ||
	'Triggers: '||chr(10)||COALESCE(get_enab_triggers(tablename),'')|| chr(10) ||
	'Disabled Triggers: '||chr(10)||COALESCE(get_dis_triggers(tablename),'') into value;
return value;
END;
$$ LANGUAGE PLPGSQL;

======================================================================================================

CREATE or REPLACE FUNCTION get_relation(tablename text)
returns table(result text) as $$
BEGIN
 RETURN QUERY select * from get_name(tablename) UNION
select * from get_table(tablename) UNION
select * from get_index(tablename) UNION
select * from get_check_constrains(tablename) UNION
select * from get_rules(tablename) UNION
select * from get_foreign_key(tablename) UNION
select * from get_referenced(tablename) UNION
select * from get_enab_triggers(tablename) UNION
select * from get_dis_triggers(tablename);
end; $$
language plpgsql;


CREATE or REPLACE FUNCTION get_re(tablename text)
returns table(c text) as $$
BEGIN
select get_name(tablename);
select get_table_details(tablename);
select get_index(tablename);
select get_check_constrains(tablename);
select get_rules(tablename);
select get_foreign_key(tablename);
select get_referenced(tablename);
select get_enab_triggers(tablename);
select get_dis_triggers(tablename);
end; $$
language plpgsql;


CREATE or REPLACE FUNCTION get_rel(tablename text)
returns void as $$
BEGIN
raise notice '%',get_name(tablename);
raise notice '%',get_table_details(tablename);
raise notice '%',get_index(tablename);
raise notice '%',get_check_constrains(tablename);
raise notice '%',get_rules(tablename);
raise notice '%',get_foreign_key(tablename);
raise notice '%',get_referenced(tablename);
raise notice '%',get_enab_triggers(tablename);
raise notice '%',get_dis_triggers(tablename);
end; $$
language plpgsql;

CREATE or REPLACE FUNCTION get_re(tablename text)
returns text as $$
BEGIN
PERFORM get_name(tablename);
PERFORM get_table_details(tablename);
PERFORM get_index(tablename);
PERFORM get_check_constrains(tablename);
PERFORM get_rules(tablename);
PERFORM get_foreign_key(tablename);
PERFORM get_referenced(tablename);
PERFORM get_enab_triggers(tablename);
PERFORM get_dis_triggers(tablename);
end; $$
language plpgsql;

=============================================================================================================================================

CREATE or REPLACE FUNCTION get_re(tablename text)
returns table(c text) as $$
BEGIN
select get_name(tablename);
select get_table_details(tablename);
select get_index(tablename);
select get_check_constrains(tablename);
select get_rules(tablename);
select get_foreign_key(tablename);
select get_referenced(tablename);
select get_enab_triggers(tablename);
select get_dis_triggers(tablename);
end; $$
language plpgsql;


CREATE or REPLACE FUNCTION get_rel(tablename text)
returns text as $$
DECLARE 
value text;
BEGIN
select COALESCE(get_name(tablename)|| chr(10) || get_table_details(tablename)|| chr(10) ||
	get_index(tablename)|| chr(10) ||get_check_constrains(tablename)|| chr(10) ||
	get_rules(tablename)|| chr(10) ||get_foreign_key(tablename)|| chr(10) ||get_referenced(tablename)|| chr(10) ||
	get_enab_triggers(tablename)|| chr(10) ||get_dis_triggers(tablename)) into value;
return value;
END;
$$ LANGUAGE PLPGSQL;




