========================================================================================================================================

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


CREATE OR REPLACE FUNCTION get_table_header(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT 	rpad('Column',MAX(LENGTH(colunm)) OVER())||chr(9)|| '|' || chr(32) 
	||  rpad('Type', MAX(LENGTH(type)) OVER()) || chr(9) || '|' || chr(32) 
	|| 	rpad('Collation', MAX(LENGTH(collations)) OVER ()) || chr(9) || '|' || chr(32)
	|| 	rpad('Nullable', MAX(LENGTH(nullable)) OVER ()) || chr(9) || '|' || chr(32) 
	|| 	rpad('Default', MAX(LENGTH(defaults)) OVER()) || chr(10)
	||	'-------------------------------------------------------------------------------------------' into output FROM
	(SELECT A.attname AS colunm, 
		pg_catalog.format_type (A.atttypid, A.atttypmod) AS type, 
		COALESCE((SELECT c.collname FROM pg_catalog.pg_collation c, pg_catalog.pg_type t
   		WHERE c.oid = A.attcollation AND t.oid = A.atttypid AND A.attcollation <> t.typcollation),'         ') AS collations,
		CASE A.attnotnull WHEN 't' THEN 'not null' WHEN 'f' THEN 'null  ' END AS nullable,
		COALESCE (( SELECT SUBSTRING ( pg_catalog.pg_get_expr (d.adbin, d.adrelid) FOR 128 ) 
			FROM pg_catalog.pg_attrdef d WHERE d.adrelid = A.attrelid AND d.adnum = A.attnum AND A.atthasdef ),'         ') AS defaults
		FROM pg_catalog.pg_attribute A WHERE A.attrelid = get_oid(tablename) AND A.attnum > 0 AND NOT A.attisdropped ORDER BY A.attnum )T;
return output;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION get_table_details(tablename text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg (data, chr(10)) into output FROM
(SELECT rpad(colunm, MAX(LENGTH(colunm)) OVER()) || chr(9) || '|' || chr(32) 
	|| rpad(type, MAX(LENGTH(type)) OVER()) || chr(9) || '|' || chr(32) 
	|| rpad(collations, MAX(LENGTH(collations)) OVER ()) || chr(9) || '|' || chr(32)
	|| rpad(nullable, MAX(LENGTH(nullable)) OVER ()) || chr(9) || '|' || chr(32) 
	|| rpad(defaults, MAX(LENGTH(defaults)) OVER()) || chr(9) || '|' || chr(32) AS data FROM 
	(SELECT A.attname AS colunm, 
		pg_catalog.format_type (A.atttypid, A.atttypmod) AS type, 
		COALESCE((SELECT c.collname FROM pg_catalog.pg_collation c, pg_catalog.pg_type t
   		WHERE c.oid = A.attcollation AND t.oid = A.atttypid AND A.attcollation <> t.typcollation),'         ') AS collations,
		CASE A.attnotnull WHEN 't' THEN 'not null' WHEN 'f' THEN 'null  ' END AS nullable,
		COALESCE (( SELECT SUBSTRING ( pg_catalog.pg_get_expr (d.adbin, d.adrelid) FOR 128 ) 
			FROM pg_catalog.pg_attrdef d WHERE d.adrelid = A.attrelid AND d.adnum = A.attnum AND A.atthasdef ),'         ') AS defaults
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

CREATE or REPLACE FUNCTION get_table_relation(tablename text)
returns text as $$
DECLARE 
value text;
BEGIN
select chr(9)||chr(9)||chr(9)||chr(9)||chr(9)|| get_name(tablename)|| chr(10) ||
	get_table_header(tablename)|| chr(10) || 
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

CREATE or REPLACE view show_sys_views as 
(SELECT c.relname AS table_name, n.nspname AS table_schema,
        pg_catalog.pg_get_userbyid(c.relowner) AS table_owner
    FROM pg_catalog.pg_class c
         LEFT JOIN pg_catalog.pg_namespace n ON (n.oid = c.relnamespace)
    WHERE c.relkind  = 'v');

CREATE or REPLACE view show_views as 
select table_name from INFORMATION_SCHEMA.views 
WHERE table_schema = ANY (current_schemas(false));

=============================================================================================================================================

get_viewname(viewname text)
get_view_header(viewname text)
get_view_details(viewname text)
get_view_relation(viewname text)

get_function_header(functionname text)
get_function_details(functionname text)

======================================================

CREATE OR REPLACE FUNCTION get_viewname(viewname text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT 'View "'||n.nspname||'.'||c.relname||'"' into output
FROM pg_catalog.pg_class c
     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname OPERATOR(pg_catalog.~) concat('^(',viewname,')$')
  AND pg_catalog.pg_table_is_visible(c.oid);
return output;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION get_view_header(viewname text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT 	rpad('Column',MAX(LENGTH(colunm)) OVER())||chr(9)|| '|' || chr(32) 
	||  rpad('Type', MAX(LENGTH(type)) OVER()) || chr(9) || '|' || chr(32) 
	|| 	rpad('Collation', MAX(LENGTH(collations)) OVER ()) || '|' || chr(32)
	|| 	rpad('Nullable', MAX(LENGTH(nullable)) OVER ()) || '|' || chr(32) 
	|| 	rpad('Default', MAX(LENGTH(defaults)) OVER()) || chr(10)
	||	'-------------------------------------------------------------------------------------------' into output FROM
		(SELECT a.attname as colunm,
  		pg_catalog.format_type(a.atttypid, a.atttypmod) as type,
  		COALESCE((SELECT c.collname FROM pg_catalog.pg_collation c, pg_catalog.pg_type t
   		WHERE c.oid = a.attcollation AND t.oid = a.atttypid AND a.attcollation <> t.typcollation),'         ') AS collations,
  		CASE a.attnotnull WHEN 't' THEN 'not null' WHEN 'f' THEN '         ' END AS nullable,
  		COALESCE ((SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)      
  		FROM pg_catalog.pg_attrdef d
  		WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef),'         ') AS defaults
		FROM pg_catalog.pg_attribute a
		WHERE a.attrelid = get_oid(viewname) AND a.attnum > 0 AND NOT a.attisdropped)T;
return output;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION get_view_details(viewname text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT string_agg(data,chr(10)) into output FROM
(SELECT rpad(colunm,MAX(LENGTH(colunm)) OVER())||chr(9)|| '|' || chr(32) 
	||  rpad(type, MAX(LENGTH(type)) OVER()) || chr(9) || '|' || chr(32) 
	|| 	rpad(collations, MAX(LENGTH(collations)) OVER ()) || chr(9) || '|' || chr(32)
	|| 	rpad(nullable, MAX(LENGTH(nullable)) OVER ()) || chr(9) || '|' || chr(32) 
	|| 	rpad(defaults, MAX(LENGTH(defaults)) OVER()) || chr(9) || chr(32) AS data FROM
		(SELECT a.attname as colunm,
  		pg_catalog.format_type(a.atttypid, a.atttypmod) as type,
  		COALESCE((SELECT c.collname FROM pg_catalog.pg_collation c, pg_catalog.pg_type t
   		WHERE c.oid = a.attcollation AND t.oid = a.atttypid AND a.attcollation <> t.typcollation),'		') AS collations,
  		CASE a.attnotnull WHEN 't' THEN 'not null' WHEN 'f' THEN '' END AS nullable,
  		COALESCE ((SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)      
  		FROM pg_catalog.pg_attrdef d
  		WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef),'		') AS defaults
		FROM pg_catalog.pg_attribute a
		WHERE a.attrelid = get_oid(viewname) AND a.attnum > 0 AND NOT a.attisdropped)T)T;
return output;
end; $$
language plpgsql;


CREATE or REPLACE FUNCTION get_view_relation(viewname text)
returns text as $$
DECLARE 
value text;
BEGIN
select chr(10)||chr(9)||chr(9)||chr(9)||get_viewname(viewname) || chr(10) || 
 get_view_header(viewname)||chr(10) ||
 get_view_details(viewname) into value;
return value;
END;
$$ LANGUAGE PLPGSQL;

=====================================================

CREATE OR REPLACE FUNCTION get_function_header(functionname text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT chr(9)||chr(9)||chr(9)||'List of functions'||chr(10)||chr(32)
||string_agg(value,chr(10))||chr(10)||
'-------------------------------------------------------------------------------------------' into output FROM
(SELECT 
 rpad('Schema',MAX(LENGTH(schema)) OVER())||chr(9)|| '|' 
 ||rpad('name',MAX(LENGTH(name)) OVER())||chr(9)|| '|' 
 ||rpad('result_data_type',MAX(LENGTH(result_data_type)) OVER())||chr(9)|| '|' 
 ||rpad('argument_data_types',MAX(LENGTH(argument_data_types)) OVER())||chr(9)|| '|' 
 ||rpad('type',MAX(LENGTH(type)) OVER())||chr(9) as value FROM
 (SELECT n.nspname as "schema",
 p.proname as "name",
 pg_catalog.pg_get_function_result(p.oid) as "result_data_type",
 pg_catalog.pg_get_function_arguments(p.oid) as "argument_data_types",
 CASE WHEN p.proisagg THEN 'agg'
 WHEN p.proiswindow THEN 'window'
 WHEN p.prorettype = 'pg_catalog.trigger'::pg_catalog.regtype THEN 'trigger'
 ELSE 'normal'
 END as "type"
 FROM pg_catalog.pg_proc p
 LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
 WHERE p.proname OPERATOR(pg_catalog.~) concat('^(',functionname,')$') AND pg_catalog.pg_function_is_visible(p.oid))T)T;
return output;
end; $$
language plpgsql;


CREATE OR REPLACE FUNCTION get_function_details(functionname text)
RETURNS text AS $$
DECLARE
output text;
BEGIN
SELECT get_function_header(functionname)||chr(10)||string_agg(value,chr(10)) into output FROM 
(SELECT rpad(schema,MAX(LENGTH(schema)) OVER())||chr(9)|| '|' || chr(32) 
	||  rpad(name, MAX(LENGTH(name)) OVER()) || chr(9) || '|' || chr(32) 
	|| 	rpad(result_data_Type, MAX(LENGTH(result_data_Type)) OVER ()) || chr(9) || '|' || chr(32)
	|| 	rpad(argument_data_types, MAX(LENGTH(argument_data_types)) OVER ()) || chr(9) || '|' || chr(32) 
	|| 	rpad(type, MAX(LENGTH(type)) OVER()) || chr(9) || chr(32) AS value FROM
	(SELECT n.nspname as "schema",
	p.proname as "name",
	pg_catalog.pg_get_function_result(p.oid) as "result_data_type",
	pg_catalog.pg_get_function_arguments(p.oid) as "argument_data_types",
	CASE WHEN p.proisagg THEN 'agg'
	WHEN p.proiswindow THEN 'window'
	WHEN p.prorettype = 'pg_catalog.trigger'::pg_catalog.regtype THEN 'trigger'
	ELSE 'normal'
	END as "type"
	FROM pg_catalog.pg_proc p
	LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
	WHERE p.proname OPERATOR(pg_catalog.~) concat('^(',functionname,')$') AND pg_catalog.pg_function_is_visible(p.oid))T)T;
return output;
end; $$
language plpgsql;

=======================================================================================================================================

