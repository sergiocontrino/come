--  SET DOC OFF
--  *************************************************************
--
--  Purpose:
--
--  Usage:   add_syn issn 'title'
--  NB       don't forget the ''  
--
--  $Source: /ebi/services/tools/seqdb/sp/sql/journals/RCS/add_syn.sql,v $
--  $Date: 2001/03/23 17:55:32 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: add_syn.sql,v $
--  Revision 1.1  2001/03/23 17:55:32  contrino
--  Initial revision
--
--
--  *************************************************************
--
set verify off
set feedback off
set heading off

insert into journal_synonym values ('&1', '&2');

column journal_syn format a60
select issn#, journal_syn from journal_synonym where journal_syn='&2';

set verify on
set feedback on
set heading on