select embl_abbrev||'|'|| issn# from cv_journal where issn# like 'S%'
union
select embl_abbrev||'|'|| issn# from cv_journal where issn# like 'T%'
union
select embl_abbrev||'|'|| issn# from cv_journal where issn# like 'E%'
;





select c.issn#, i.issn 
from interpro.journal@iprod i, cv_journal c
where c.issn# in
(select issn#||'|'|| embl_abbrev from cv_journal where issn# like 'S%'
union
select issn#||'|'|| embl_abbrev from cv_journal where issn# like 'T%'
union
select issn#||'|'|| embl_abbrev from cv_journal where issn# like 'E%'
)
and upper(c.embl_abbrev)=upper(i.abbrev)
;

select c.issn#, i.issn 
from interpro.journal_syn@iprod i, cv_journal c
where c.issn# in
(select issn#||'|'|| embl_abbrev from cv_journal where issn# like 'S%'
union
select issn#||'|'|| embl_abbrev from cv_journal where issn# like 'T%'
union
select issn#||'|'|| embl_abbrev from cv_journal where issn# like 'E%'
)
and upper(c.embl_abbrev)=upper(i.text)
;
