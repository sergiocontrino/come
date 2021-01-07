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

prompt
prompt Please enter child id:
accept chi

delete from come.relations
where id = (select id from come.entry where old_id='&chi')
and parent = (select id from come.entry where old_id='&1')
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
