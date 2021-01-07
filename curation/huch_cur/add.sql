--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose:  updating of table cromoloc    
--
--  Usage:      sqlplus username/password @add gene acc chromo location status
--
--
--  $Source: /ebi/sp/pro1/HUmanCHromosome/curation/RCS/add.sql,v $
--  $Date: 2003/12/17 12:33:35 $
--  $Author: pkersey $
--
--  _____________________________________________________________
--
--  $Log: add.sql,v $
--  Revision 1.6  2003/12/17 12:33:35  pkersey
--  correcting for move to PROT.
--
--  Revision 1.5  2001/10/08 15:48:46  contrino
--  *** empty log message ***
--
--  Revision 1.4  2001/07/17 13:06:19  contrino
--  *** empty log message ***
--
--  Revision 1.3  2001/07/13 15:51:03  contrino
--  changed for new schema
--
--  Revision 1.2  2001/07/02 15:04:37  contrino
--  added evidence
--
--  Revision 1.1  2000/09/26 10:23:02  contrino
--  Initial revision
--
--
--  *************************************************************
set verify off;

COLUMN GENE format a15
column acc  format a6
column chromosome format a2
column location format a16
column status format a1 head "s"
column source format a1 head S
column userstamp format a5
COLUMN Gid format 99999
column loclink format 999999 head "LLid"

declare
p_gid number(6);

begin
select proteomes.seq_gid.nextval into p_gid from dual;

insert into proteomes.cromoloc ( gid, gene, acc, chromosome, location, status )
values ( p_gid , '&1',  '&2',  '&3', '&4', '&5')
;

insert into proteomes.cromosptr ( gid, acc )
values ( p_gid ,  '&2')
;
end;
/


prompt Your new record looks now like that:
prompt
select gid, gene, acc, chromosome, location, status, loclink
from proteomes.cromoloc where gene='&1';


set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
