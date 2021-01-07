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


set verify off

@show '&1'




prompt
prompt Please enter entry name:
accept name
prompt Please enter entry coordination if applicable:
accept coord


insert into come.entry (id, name, old_id, coordination)
values (seq_ids.nextval, '&name', '&1', '&coord')
;

prompt "The record you have insertd is :"
select id, name, old_id, coordination
from come.entry
where name = '&name'
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
