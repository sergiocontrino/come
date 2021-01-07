--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose: deleting from table cromosptr    
--
--  Usage:   sqlplus username/password acc-to-be-deleted 
--     
--  note:    it will ask for the acc
--
--
--  $Source: /homes/contrino/huch/curation/RCS/delsptr.sql,v $
--  $Date: 2002/05/01 10:57:01 $
--  $Author: contrino $
--  ____________________________________________________________
--  
--  $Log: delsptr.sql,v $
--  Revision 1.1  2002/05/01 10:57:01  contrino
--  Initial revision
--
--
--  *************************************************************

set verify off

accept gid prompt 'Please enter the relevant gid for &1: '

delete from proteomes.cromosptr
where acc='&1'
and gid=&gid
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
