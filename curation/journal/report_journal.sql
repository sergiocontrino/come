set pages 200

column title format a68
column issn format a10

spool /homes/contrino/sptr_journal.report

select issn# "issn", embl_abbrev "title" 
from cv_journal where issn# like 'S%'
order by 2
;

spool off;
