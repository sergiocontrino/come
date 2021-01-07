--  SET DOC OFF
--  ****************************************************************************
--
--  Purpose:    
--
--  Usage:      sqlplus username/password @upd entry-to-be-updated
--
--
--  $Source$
--  $Date$
--  $Author$
--  ____________________________________________________________________________
--  $Log$
--  ****************************************************************************

column name format a55
column type  format a1 heading 'T'
column old_id format a10 heading 'ID'
column coordination format a8 heading 'COORD.'
column formula format a5

set verify off
prompt
accept col prompt 'What would you like to update? [NAME, COORDINATION]: '
prompt
accept value  prompt 'Please give me a value: '
prompt

update come.entry
set &col ='&value'
where old_id = upper('&1')
;

set feedback off
prompt
prompt Your updated record looks now like that:
prompt
select  old_id, name, coordination 
from come.entry where old_id = upper('&1');

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
