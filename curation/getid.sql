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
set feedback off
set heading off
set timing off

select old_id from entry where id = &1;

prompt 

set timing on
set feedback on
set heading on
