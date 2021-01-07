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
prompt Please enter entry id:
accept id

delete from come.entry
where old_id = '&id'
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
