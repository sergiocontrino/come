--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose: updating acc in cromoloc schema    
--
--  Usage:   sqlplus username/password @uacc gene-to-be-updated old_acc
--
--
--  $Source: /homes/contrino/huch/curation/RCS/uacc.sql,v $
--  $Date: 2001/10/08 15:49:33 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: uacc.sql,v $
--  Revision 1.4  2001/10/08 15:49:33  contrino
--  *** empty log message ***
--
--  Revision 1.3  2001/07/17 13:04:58  contrino
--  now requires also old acc# in the command line
--
--  Revision 1.2  2001/07/16 13:05:18  contrino
--  *** empty log message ***
--
--  Revision 1.1  2001/07/13 15:53:03  contrino
--  Initial revision
--
--
--  *************************************************************
COLUMN GENE format a15
column acc  format a6
column chromosome format a2
column location format a16
column status format a1 head "s"
column source format a1 head S
column userstamp format a5
COLUMN Gid format 99999
column loclink format 999999 head "LLid"

set verify off
prompt 
accept new_acc prompt 'Please give me the new acc: '

update proteomes.cromoloc
set acc = upper('&new_acc')
where upper(gene)=upper('&1')
;

declare
p_gid number(6);

begin
select gid into p_gid from proteomes.cromoloc where upper(gene) = upper('&1');

update proteomes.cromosptr
set acc=upper('&new_acc')
where gid=p_gid
and acc = upper('&2')
;
end;
/


set feedback off
prompt
prompt Your updated record looks now like that:
prompt
select l.gid, l.gene, s.acc, l.chromosome, l.location, l.status, l.loclink
from proteomes.cromoloc l, proteomes.cromosptr s
where upper(gene) = upper('&1')
and s.gid = l.gid
;

prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
