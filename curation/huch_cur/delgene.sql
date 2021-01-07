--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose:  deleting from table cromoloc    
--
--  Usage:      sqlplus username/password gene-to-be-deleted 
--     
--  note:   it will delete also from cromosptr (delete cascade)
--
--
--  $Source: /ebi/sp/pro1/HUmanCHromosome/curation/RCS/delgene.sql,v $
--  $Date: 2003/12/17 12:33:52 $
--  $Author: pkersey $
--
--  _____________________________________________________________
--
--  $Log: delgene.sql,v $
--  Revision 1.2  2003/12/17 12:33:52  pkersey
--  correcting for move to PROT.
--
--  Revision 1.1  2003/12/12 09:18:08  pkersey
--  Initial revision
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
where gene='&1'
;

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
