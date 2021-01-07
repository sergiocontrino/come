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

column old_id format a10 heading ID
column instance format a25 heading NAME
column species format a12
column state format a10
column centre format a10



set verify off
prompt
accept col prompt 'What would you like to update? [NAME, SPECIES, STATE, CENTRE]: '
prompt
accept value  prompt 'Please give me a value: '
prompt

update come.instance
set &col = '&value'
where instance = '&1'
;

set feedback off
prompt
prompt Your updated record looks now like that:
prompt

select i.instance, i.species, i.state, i.centre
from come.instance i
where i.instance = '&1'
;
select i.instance, i.species, i.state, i.centre
from come.instance i
where i.instance = '&value'
;


prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
