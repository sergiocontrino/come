set feedback off
set pages 1000

COLUMN GENE format a20
column acc  format a6
column chromosome format a2
column location format a20
column status format a12
column source format a10
column userstamp format a9


spool /homes/contrino/public_html/cromo/reports/stats

prompt
prompt === GENES and ACC Nr ===

select count (distinct gene) "Genes", 
count (distinct acc) "Acc Nr"
from proteomes.cromoloc;

select count (*) "Unmapped" from proteomes.cromoloc where location = 'NA';

prompt ________________________
prompt
prompt === LOCATION SOURCE  ===
select decode (source, 
'3', 'TrEMBL', 'E', 'Ensembl', 'S', 'SP', 'U', 'U', 'null') "Source",
count(*) "Nr" from proteomes.cromoloc group by source order by 2 desc;

prompt ________________________
prompt
prompt === GENE NAME STATUS ===
select decode (status, 
'H', 'Accepted', 'P', 'Preliminary', 'others') "Status",
count(*) "Nr" from proteomes.cromoloc group by status order by 2 desc;

prompt ________________________
prompt
prompt ==  CHROMOSOME COUNT  ==
select chromosome, count(*) "Genes"
from proteomes.cromoloc
group by chromosome
order by count(*) desc
;

set heading off
prompt -------------;

select 'Tot.:   '|| count(*) from proteomes.cromoloc;

prompt ________________________
select '            ', sysdate from dual;



set heading on
set feedback on

prompt

spool off;

