--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose:  updating of table cromoloc    
--
--  Usage:      sqlplus username/password @upd gene-to-be-updated
--
--
--  $Source: /ebi/sp/pro1/HUmanCHromosome/curation/RCS/update.sql,v $
--  $Date: 2003/12/12 09:24:08 $
--  $Author: pkersey $
--
--  _____________________________________________________________
--
--  $Log: update.sql,v $
--  Revision 1.6  2003/12/12 09:24:08  pkersey
--  fixing for PROT use.
--
--  Revision 1.5  2003/09/10 14:31:50  youla
--  *** empty log message ***
--
--  Revision 1.4  2003/09/04 15:09:51  youla
--  *** empty log message ***
--
--  Revision 1.3  2001/07/17 13:08:25  contrino
--  *** empty log message ***
--
--  Revision 1.2  2001/07/13 16:05:09  contrino
--  search case insensitive (not insert)
--
--  Revision 1.1  2000/09/26 10:26:43  contrino
--  Initial revision
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
where upper(gene)=upper('&1')
;

set feedback off
prompt
prompt Your updated record looks now like that:
prompt
select  gid, gene, acc, chromosome, location, status, source, loclink
from proteomes.cromoloc where upper(gene)=upper('&1');

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
