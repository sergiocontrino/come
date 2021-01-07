--  SET DOC OFF
--  ****************************************************************************
--
--  Purpose: to build the dot file describing the paths through the given entry. 
--           dot file is then used by graphviz to build the image map (and gif).
--
--  Usage:   @upath come_old_id    (e.g. @upath PRX000123) 
--
--  Notes:   it is a series of sql stmts that spool to the same file.
--           there is the need to escape some chars (see replace).
--  
--  TODOS:   some (3) files too big
--           better formatting?         
--
--  $Source: /homes/contrino/come/gv/RCS/upath.sql,v $
--  $Date: 2004/03/23 17:04:00 $
--  $Author: contrino $
--  ____________________________________________________________________________
--  
--  $Log: upath.sql,v $
--  Revision 1.7  2004/03/23 17:04:00  contrino
--  longer line now (it was trncated..)
--
--  Revision 1.6  2003/12/03 14:33:12  contrino
--  label and location of files
--
--  ****************************************************************************

set pages 0
set feedback off
set verify off
set lin 150

prompt &1

set term off

spool &1

select 'digraph '||'&1'||' {
graph [
label = "Active map of COMe paths through \n'||
name||'\n('||'&1'||')",
labelloc=t,
nodesep=0.05,
ranksep=0.05,
URL = "http://www.ebi.ac.uk/come/entry?gn=\G",
ratio=auto,
fontsize=12];'
||
'node [
color=orange,
style=filled,
fontsize=9,
shape = record, 
URL = "http://www.ebi.ac.uk/come/entry?gn=\N"];'
||
'edge [
fontsize=8
];'
from entry
where old_id='&1'
;

select distinct e.old_id||' [ 
label="'||replace(replace(replace( e.name,'{','\{'), '}', '\}'),'|','\|')||'",
tooltip="'||e.old_id||'",
color='||decode(substr(e.old_id,1,3),'PRX', 'azure3', 'MOL', 'palegreen', 'BIM', 'khaki', 'orange')||']'
from entry e
where e.id  
in 
(select id
from path p
where p.path in
(select path 
from path pp, entry ee
where pp.id = ee.id 
and ee.old_id='&1'
)
)
;

prompt
prompt


SELECT distinct e.old_id||' -> '|| ee.old_id,
'[label="'||pp.rel||'"]'
FROM path p, path pp, entry e, entry ee
WHERE 
p.path = pp.path
and e.id = pp.id
and ee.id = pp.child
and e.old_id != ee.old_id
and p.id =
(select id from entry where old_id = '&1')
;

prompt }

spool off

--! mv &1\.lst /homes/contrino/viz/gv/comedot/&1
! mv &1\.lst /net/nfs6/vol4/ma-db/sergio/comedot/&1

set term on
set feedback on

