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

declare
v_type varchar2(1);

begin
dbms_output.enable ( 1000000 );

select upper(substr('&1',1,1)) into v_type from dual;

DBMS_OUTPUT.PUT_LINE('par: ' || v_type); 

if ( v_type = 'B') then

DBMS_OUTPUT.PUT_LINE('B'); 
@updB

else

DBMS_OUTPUT.PUT_LINE('PM'); 

end if;

end;
/


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
