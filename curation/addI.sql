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
column instance format a25 heading NAME
column species format a12
column state format a10
column centre format a10
column dbabbrev format a10 heading DB
column dbid format a35 heading DBID

set doc off
set timing off
set verify off
set feedback off

--prompt
--prompt Please enter entry ID:
--accept id
prompt
prompt Please enter instance NAME:
accept name
prompt
prompt Please enter instance SPECIES:
accept species
prompt
prompt Please enter instance STATE:
accept state
prompt
prompt Please enter instance CENTRE:
accept centre
prompt
prompt Please enter DB NAME...
accept dbin
prompt
prompt ..and DB IDentifier:
accept dbid


insert into come.instance (id_instance, instance, species, state, centre)
values (come.seq_ids.nextval, '&name', '&species','&state','&centre')
;

update come.instance
set id = (select id from come.entry where old_id = '&1')
where instance = '&name'
;


insert into come.db_xref (id_dbx, id_come, dbcode, dbid)
select come.seq_ids.nextval, e.id_instance, d.dbcode, upper('&dbid')
from come.instance e, come.database d
where e.instance = '&name'
and upper(d.dbabbrev) = upper('&dbin')
;

prompt
prompt The record you have inserted is :

select e.old_id, i.instance, i.species, i.state, i.centre
from come.entry e, come.instance i
where e.id = i.id
and i.instance = '&name'
;

select d.dbabbrev, dx.dbid
from come.instance e, come.db_xref dx, come.database d
where dx.id_come = e.id_instance
and dx.dbcode = d.dbcode
and e.instance = '&name'
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

