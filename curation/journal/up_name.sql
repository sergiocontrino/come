--  SET DOC OFF
--  *************************************************************
--
--  Purpose:    to update a journal name in the controlled vocabulary
--              of the sp schema
--
--  Usage:      up_name issn 'new_name' 
--
--  NB:         remember the '' for new_name..
--
--  $Source$
--  $Date$
--  $Author$
--
--  *************************************************************

set verify off;
set feedback off;
set heading off;

column embl_abbrev format a60
prompt -----------;

select issn#, embl_abbrev from cv_journal where issn#='&1';

update cv_journal set embl_abbrev ='&2'
where issn#='&1';

prompt
prompt became

select issn#, embl_abbrev from cv_journal where issn#='&1';
set feedback on;
set heading on;

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
prompt -----;

