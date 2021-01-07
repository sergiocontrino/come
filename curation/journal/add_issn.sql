--  SET DOC OFF
--  *************************************************************
--
--  Purpose:
--
--  Usage:   add_issn issn 'title'
--  NB       don't forget the ''  
--
--
--  $Source: /ebi/services/tools/seqdb/sp/sql/journals/RCS/add_issn.sql,v $
--  $Date: 2001/03/23 17:56:04 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: add_issn.sql,v $
--  Revision 1.1  2001/03/23 17:56:04  contrino
--  Initial revision
--
--
--  *************************************************************
--
set verify off
set feedback off
set heading off

insert into cv_journal values ('&1', '&2', '&2', '&2');

column embl_abbrev format a60
select issn#, embl_abbrev from cv_journal where issn#='&1';

set verify on
set feedback on
set heading on