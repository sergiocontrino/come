--  SET DOC OFF
--  *************************************************************
--
--  Purpose:
--
--  Usage:      fake_to_syn old_issn(fake) new_issn(correct)
--
--
--  $Source: /ebi/services/tools/seqdb/sp/sql/journals/RCS/fake_to_syn.sql,v $
--  $Date: 2001/03/23 17:56:40 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: fake_to_syn.sql,v $
--  Revision 1.1  2001/03/23 17:56:40  contrino
--  Initial revision
--
--
--  *************************************************************
--

set verify off;
set feedback off;
set heading off;

column embl_abbrev format a60
prompt -----------;

select embl_abbrev from cv_journal where issn#='&1';

update journalarticle set issn='&2' where issn= '&1';
update accepted set issn='&2' where issn= '&1';

declare 
jt varchar2(80);

begin
select embl_abbrev into jt from cv_journal where issn#='&1';
insert into journal_synonym (issn#, journal_syn) values ('&2', jt);
end;
/

prompt
prompt has been classified as a synonym to
select issn#, embl_abbrev from cv_journal where issn#='&2';

delete from cv_journal where issn#='&1';

prompt
prompt &1 has been deleted from cv_journal

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
prompt -----------;
