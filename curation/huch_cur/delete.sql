--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose: deleting from table cromoloc    
--
--  Usage:   sqlplus username/password gid-to-be-deleted 
--     
--  note:    it will delete also from cromosptr (delete cascade)
--
--
--  $Source: /homes/contrino/huch/curation/RCS/delete.sql,v $
--  $Date: 2001/07/17 13:16:02 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: delete.sql,v $
--  Revision 1.3  2001/07/17 13:16:02  contrino
--  uses gid instead of gene name now
--
--  Revision 1.2  2001/07/13 15:13:16  contrino
--  *** empty log message ***
--
--  Revision 1.1  2000/09/26 10:13:56  contrino
--  Initial revision
--
--
--  *************************************************************

set verify off

delete from proteomes.cromoloc
where gid=&1
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
