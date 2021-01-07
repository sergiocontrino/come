set pages 0
spool fake.all

select embl_abbrev||'|'|| issn# from cv_journal where issn# like 'S%'
union
select embl_abbrev||'|'|| issn# from cv_journal where issn# like 'T%'
union
select embl_abbrev||'|'|| issn# from cv_journal where issn# like 'E%'
;
spool off;
--exit;
