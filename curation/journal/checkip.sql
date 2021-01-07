select c.issn#, i.issn
from interpro.journal@iprod i, cv_journal c
where c.issn# like 'S%'
and upper(c.embl_abbrev)= upper(i.abbrev)
;

select c.issn#, i.issn
from interpro.journal_syn@iprod i, cv_journal c
where c.issn# like 'S%'
and upper(c.embl_abbrev)= upper(i.text)
;

