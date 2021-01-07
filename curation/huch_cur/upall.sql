--  SET DOC OFF
--  *************************************************************
--
--  Package: human chromosome
--
--  Purpose: updating of table cromoloc    
--
--  Usage:   sqlplus username/password @uall gene acc chromo location
--
--
--  $Source: /ebi/sp/pro1/HUmanCHromosome/curation/RCS/upall.sql,v $
--  $Date: 2001/07/13 16:13:24 $
--  $Author: contrino $
--
--  _____________________________________________________________
--
--  $Log: upall.sql,v $
--  Revision 1.2  2001/07/13 16:13:24  contrino
--  -changes for new schema
--  -case insensitive where sensible
--
--  Revision 1.1  2000/09/26 10:26:09  contrino
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

update proteomes.cromoloc
set acc=upper('&2'),
chromosome=upper('&3'),
location='&4'
where upper(gene)=upper('&1')
;

declare
p_gid number(6);

begin
select gid into p_gid from proteomes.cromoloc where upper(gene) = upper('&1');

update cromosptr
set acc=upper('&2')
where gid=p_gid
;
end;
/


set feedback off
prompt
prompt Your updated record looks now like that:
prompt
select l.gid, l.gene, s.acc, l.chromosome, l.location, l.status, l.loclink
from proteomes.cromoloc l, cromosptr s
where upper(gene) = upper('&1')
and s.gid = l.gid
;



prompt
prompt Your updated record looks now like that:
prompt
select * from proteomes.cromoloc where gene='&1';

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
