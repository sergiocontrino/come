--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose:  updating of table cromoloc    
--
--  Usage:      sqlplus username/password @gid_up gid-of-the-record-to-be-updated
--
--
--  $Source: /homes/contrino/huch/curation/RCS/gid_up.sql,v $
--  $Date: 2002/01/16 14:49:15 $
--  $Author: contrino $
--  ____________________________________________________________
--
--  $Log: gid_up.sql,v $
--  Revision 1.1  2002/01/16 14:49:15  contrino
--  Initial revision
--
--
--
--  *************************************************************
COLUMN GENE format a20
column acc  format a6
column chromosome format a2
column location format a20
column status format a1
column source format a1
column userstamp format a9

set verify off
prompt
prompt 'Please use uacc if you want to update an accession number'
prompt
accept col prompt 'What would you like to update? [CHROMOSOME, LOCATION,..]: '
prompt
accept value  prompt 'Please give me a value: '
prompt

update proteomes.cromoloc
set &col ='&value'
where gid =&1
;

set feedback off
prompt
prompt Your updated record looks now like that:
prompt
select  gid, gene, acc, chromosome, location, status, loclink
from proteomes.cromoloc where gid = &1;

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
