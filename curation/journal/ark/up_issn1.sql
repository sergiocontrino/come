-- USAGE up_issn old_issn new_issn 
set verify off;
set feedback off;
set heading off;

prompt -----;
insert into cv_journal (issn#, embl_abbrev, full_name) values ('&2', '&1', '&1');
update journalarticle set issn='&2' where issn= '&1';
update accepted set issn='&2' where issn= '&1';

select issn#, embl_abbrev from cv_journal where issn#='&1';

declare 
jt varchar2(80);

begin
select embl_abbrev into jt from cv_journal where issn#='&1';
update cv_journal set embl_abbrev =jt, full_name=jt where issn#='&2';
end;
/

delete from cv_journal where issn#='&1';
select issn#, embl_abbrev from cv_journal where issn#='&2';

set feedback on
