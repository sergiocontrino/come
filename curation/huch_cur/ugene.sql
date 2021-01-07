--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose:  updating of table cromoloc    
--
--  Usage:    sqlplus username/password @ugene gene-to-be-updated
--
--
--  $Source: /ebi/sp/pro1/HUmanCHromosome/curation/RCS/ugene.sql,v $
--  $Date: 2003/12/12 09:25:07 $
--  $Author: pkersey $
--
--  _____________________________________________________________
--
--  $Log: ugene.sql,v $
--  Revision 1.6  2003/12/12 09:25:07  pkersey
--  fixing for PROT use.
--
--  Revision 1.5  2003/09/10 14:32:32  youla
--  *** empty log message ***
--
--  Revision 1.4  2003/09/04 15:10:15  youla
--  *** empty log message ***
--
--  Revision 1.3  2001/07/13 15:50:20  contrino
--  search case insensitive now
--
--  Revision 1.2  2001/06/29 10:12:33  contrino
--  status is no longer set to null.
--
--  Revision 1.1  2000/09/26 10:24:32  contrino
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
accept new_gene prompt 'Please give me the new gene name: '

update proteomes.cromoloc
set gene ='&new_gene'
where upper(gene) = upper('&1')
;

prompt
prompt Your updated record looks now like that:
prompt
select gid, gene, acc, chromosome, location, status, source, loclink
from proteomes.cromoloc where gene='&new_gene';

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
