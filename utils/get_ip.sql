set pages 0
set lin 200
set feedback off
spool /homes/contrino/ip.xref
select d.dbid||'   '||e.old_id||' '|| 
'"'||e.name||'"'||' '|| 
'http://www.ebi.ac.uk/come/entry?gn='||e.old_id
from entry e, db_xref d
where e.id=d.id_come
and d.dbcode='IP'
;
spool off


/*
union
select d.dbid, e.old_id, 
'"'||e.name||'"', 
'http://www.ebi.ac.uk/come/entry?gn='||e.name
from entry e, db_xref d, instance i
where i.id=d.id_come
and   e.id=i.id
and d.dbcode='IP'
;
*/
