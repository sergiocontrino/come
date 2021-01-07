column name format a20
column instance format a20
column dbcode format a2
column dbid format a9
column brick_type format a2 head ty
column id format 9999

break on id on name on instance

set verify off;

--accept bim prompt 'please enter BIM: '

select e.id, e.name, i.instance, d.dbcode, d.dbid 
from entry e, instance i, db_xref d
where e.id = i.id(+)
and ((d.id_come = i.id_instance )
or (d.id_come = e.id))
and e.old_id = '&1'
;
