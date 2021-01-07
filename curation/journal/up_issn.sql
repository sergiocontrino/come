--  SET DOC OFF
--  *************************************************************
--
--  Purpose:    to updste a issn in the sp schema
--
--  Usage:       up_issn old_issn new_issn 
--
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

insert into cv_journal (issn#, embl_abbrev, full_name) values ('&2', '&1', '&1');
update journalarticle set issn='&2' where issn= '&1';
update accepted set issn='&2' where issn= '&1';

select issn#, embl_abbrev from cv_journal where issn#='&1';

update cv_journal 
set (embl_abbrev, full_name) = 
(select embl_abbrev, embl_abbrev from cv_journal where issn#='&1')
where issn#='&2'
;

prompt
prompt became

delete from cv_journal where issn#='&1';


select issn#, embl_abbrev from cv_journal where issn#='&2';
set feedback on;
set heading on;

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
prompt -----;
