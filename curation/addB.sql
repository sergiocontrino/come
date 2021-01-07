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
column COORDINATION format a12
column formula format a3 heading GIF
column dbabbrev format a10 heading DB
column dbid format a35 heading DBID

set doc off
set timing off
set verify off

set heading off
set feedback off

prompt
prompt The next available id is:
select 'BIM000'||(max(to_number(substr(old_id,6)))+1) 
from come.entry
where old_id like 'B%'
;

set heading on

prompt
prompt Please enter new entry ID:
accept new_id
prompt
prompt Please enter entry NAME:
accept name
prompt
prompt Please enter entry COORDINATION:
accept coor
prompt
prompt There is a formula graph for it? [y/n]:
accept gif
prompt
prompt If it has a cross-reference, please enter DB NAME...
accept dbin
prompt
prompt ..and DB IDentifier:
accept dbid


insert into come.entry (id, name, old_id, coordination, formula)
values (come.seq_ids.nextval, '&name', upper('&new_id'), upper('&coor'), decode ('&gif', 'y', 'gif', null))
;

insert into come.db_xref (id_dbx, id_come, dbcode, dbid)
select come.seq_ids.nextval, e.id, d.dbcode, upper('&dbid')
from come.entry e, come.database d
where old_id = upper('&new_id')
and upper(d.dbabbrev) = upper('&dbin')
;

prompt
prompt The record you have inserted is :

select old_id, name, coordination, formula
from come.entry e
where e.old_id= upper('&new_id')
;

select d.dbabbrev, dx.dbid
from come.entry e, come.db_xref dx, come.database d
where dx.id_come = e.id
and dx.dbcode = d.dbcode
and e.old_id= upper('&new_id')
;

prompt


set feedback off
prompt ===========================================
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on

set timing on

