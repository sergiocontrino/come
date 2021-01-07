--  ****************************************************************************
--
--  Purpose:    
--
--  Usage:      sqlplus username/password @skeleton.sql
--
--
--  $Source$
--  $Date$
--  $Author$
--  ____________________________________________________________________________
--  
--  $Log$
--  ****************************************************************************

column id format 009999

column old_id format a10 heading ID
column name format a35 heading NAME
column dbabbrev format a10 heading DB
column dbid format a35 heading DBID
column coord format a8 
column gif format a3
column children format a9
column parents format a9
column rel format a9

set doc off
set timing off
set verify off

set heading off
set feedback off

set heading on


prompt
-- prompt The record you have inserted is :

/*
select old_id, name, d.dbabbrev, dx.dbid
from come.entry e, come.db_xref dx, come.database d
where dx.id_come = e.id
and dx.dbcode = d.dbcode
and e.old_id= upper('&new_id')
;
select old_id, name, dx.dbcode "DB", dx.dbid
from come.entry e, come.db_xref dx
where dx.id_come (+) = e.id
and e.old_id= upper('&new_id')
;
*/


select old_id, name, NVL(coordination, '-') "COORD", NVL(formula, '-') "GIF"
from come.entry e
where e.old_id= upper('&1')
;

select d.dbabbrev, dx.dbid
from come.entry e, come.db_xref dx, come.database d
where dx.id_come = e.id
and dx.dbcode = d.dbcode
and e.old_id= upper('&1')
;

select e.old_id "CHILDREN", r.ptoc "REL"
from come.relations r, come.entry e
where r.parent = (select id from come.entry where old_id='&1')
and e.id = r.id
;

select e.old_id "PARENTS", r.type "REL"
from come.relations r, come.entry e
where r.id =  (select id from come.entry where old_id='&1')
and r.parent = e.id
;

prompt

set timing on

