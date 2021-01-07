--  SET DOC OFF
--  *************************************************************
--
--  Purpose:
--
--  Usage:   add_fake 'title'
--  NB       don't forget the ''  
--
--
--  $Source: /ebi/services/tools/seqdb/sp/sql/journals/RCS/add_fake.sql,v $
--  $Date: 2001/03/23 17:56:30 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: add_fake.sql,v $
--  Revision 1.1  2001/03/23 17:56:30  contrino
--  Initial revision
--
--
--  *************************************************************
--
set verify off
set feedback off
set heading off

insert into cv_journal values ('SPTR-'||to_char(issn_seq.nextval, 'fm0999'), '&1', '&1', '&1');

column embl_abbrev format a60
select issn#, embl_abbrev from cv_journal where embl_abbrev='&1';

set verify on
set feedback on
set heading on