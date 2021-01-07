--  SET DOC OFF
--  ****************************************************************************--
--  Purpose:    
--
--  Usage:      sqlplus username/password @skeleton.sql
--
--
--  $Source$
--  $Date$
--  $Author$
--  ____________________________________________________________________________--  
--  $Log$
--  ****************************************************************************

column id format 009999

column old_id format a9 heading ID
column name format a35 heading NAME
column dbabbrev format a10 heading DB
column dbid format a20 heading DBID


set timing off
set verify off

set heading off
set feedback off

prompt The last id is:
select 'PRX00'||(max(to_number(substr(old_id,5)))) 
from come.entry
where old_id like 'P%'
;

set heading on

prompt
prompt Please enter new entry ID:
accept new_id
prompt
prompt Please enter entry NAME:
accept name
prompt
prompt If it has a cross-reference, please enter DB NAME:
accept dbin
prompt
prompt ..and DB IDentifier:
accept dbid


insert into come.entry (id, name, old_id)
values (come.seq_ids.nextval, '&name', upper('&new_id'))
;

insert into come.db_xref (id_dbx, id_come, dbcode, dbid)
select come.seq_ids.nextval, e.id, d.dbcode, upper('&dbid')
from come.entry e, come.database d
where old_id = upper('&new_id')
and upper(d.dbabbrev) = upper('&dbin')
;



prompt The record you have insertd is :
select old_id, name, d.dbabbrev, dx.dbid
from come.entry e, come.db_xref dx, come.database d
where e.id = dx.id_come
and d.dbcode = dx.dbcode
and e.old_id= upper('&new_id')
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on

set timing on

