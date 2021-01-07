-- 
-- insert xref to database (db_xref table)
--

-- prx instance --543
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'COMPOUND:'
then  'C'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'CAS:'
then  'CAS'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'EC:'
then  'EC'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'GO:'
then  'GO'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'InterPro:'
then  'IP'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDB:'
then  'P'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDBHET:'
then  'PH'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'RESID:'
then  'R'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'SPTR:'
then  'S'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'TREMBLNEW:'
then  'TN'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEROPS:'
then  'ME'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'DOI:'
then  'DO'
else 'ot' 
end,
substr(ltrim (dbx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
i.id_instance
from alfa a, entry e, instance i
where e.old_id = a.id
and e.id = i.id
and ( a.specie = i.species or i.species is null)
and ( a.state = i.state or i.state is null)
and ( a.centre = i.centre or i.centre is null)
and a.instance = i.instance
and i.instance is not null
and a.dbx is not null
)
;

-- molbim  term --123
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'COMPOUND:'
then  'C'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'CAS:'
then  'CAS'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'EC:'
then  'EC'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'GO:'
then  'GO'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'InterPro:'
then  'IP'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDB:'
then  'P'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDBHET:'
then  'PH'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'RESID:'
then  'R'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'SPTR:'
then  'S'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'TREMBLNEW:'
then  'TN'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEROPS:'
then  'ME'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'DOI:'
then  'DO'
else 'ot' 
end,
substr(ltrim (dbx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
i.id_instance
from alfa a, entry e, instance i
where e.old_id = a.id
and e.id = i.id
and e.old_id not like 'PRX%'
and a.term = i.instance
and a.dbx is not null
)
;

-- prx only term --338
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'COMPOUND:'
then  'C'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'CAS:'
then  'CAS'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'EC:'
then  'EC'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'GO:'
then  'GO'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'InterPro:'
then  'IP'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDB:'
then  'P'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDBHET:'
then  'PH'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'RESID:'
then  'R'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'SPTR:'
then  'S'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'TREMBLNEW:'
then  'TN'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEROPS:'
then  'ME'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'DOI:'
then  'DO'
else 'ot' 
end,
substr(ltrim (dbx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
e.id
from alfa a, entry e
where e.old_id = a.id
and e.old_id like 'PRX%'
and a.instance is null
and a.dbx is not null
)
;

-- molbim only name --1
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'COMPOUND:'
then  'C'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'CAS:'
then  'CAS'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'EC:'
then  'EC'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'GO:'
then  'GO'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'InterPro:'
then  'IP'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDB:'
then  'P'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PDBHET:'
then  'PH'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'RESID:'
then  'R'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'SPTR:'
then  'S'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'TREMBLNEW:'
then  'TN'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEROPS:'
then  'ME'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (a.dbx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'DOI:'
then  'DO'
else 'ot' 
end,
substr(ltrim (dbx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
e.id
from alfa a, entry e
where e.old_id = a.id
and e.old_id not like 'PRX%'
and a.term is null
and a.dbx is not null
)
;



-- ========== lref ================
-- ================================

-- prx instance --45
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (rx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (rx, ' -0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (rx, ' -0123456789./ABCDEFGHIJKLMNOPQRSTUWXYVZabcdefghijklmnopqrstuwxyvz') = 'DOI:'
then  'DO'
else substr(rx, 1,10)
end,
substr(ltrim (rx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
i.id_instance
from alfa a, entry e, instance i
where e.old_id = a.id
and e.id = i.id
and ( a.specie = i.species or i.species is null)
and ( a.state = i.state or i.state is null)
and ( a.centre = i.centre or i.centre is null)
and a.instance = i.instance
and a.rx is not null
)
;

-- molbim  term --8
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (rx, '0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (rx, '0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (rx, '0123456789./ABCDEFGHIJKLMNOPQRSTUWXYVZabcdefghijklmnopqrstuwxyvz') = 'DOI:'
then  'DO'
else substr(rx, 1,10)
end,
substr(ltrim (rx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
i.id_instance
from alfa a, entry e, instance i
where e.old_id = a.id
and e.id = i.id
and e.old_id not like 'PRX%'
and a.term = i.instance
and a.rx is not null
)
;

-- prx only term --0 3
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (rx, '0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (rx, '0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (rx, '0123456789./ABCDEFGHIJKLMNOPQRSTUWXYVZabcdefghijklmnopqrstuwxyvz') = 'DOI:'
then  'DO'
else substr(rx, 1,10)
end,
substr(ltrim (rx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
e.id
from alfa a, entry e
where e.old_id = a.id
and e.old_id like 'PRX%'
and a.instance is null
and a.rx is not null
)
;

-- molbim only name --0  2
insert into db_xref (dbcode, dbid, id_come)
(
select case 
when rtrim (rx, '0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'MEDLINE:'
then  'ML'
when rtrim (rx, '0123456789.ABCDEFGHIJKLMNOPQRSTUWXYVZ') = 'PUBMED:'
then  'PM'
when rtrim (rx, '0123456789./ABCDEFGHIJKLMNOPQRSTUWXYVZabcdefghijklmnopqrstuwxyvz') = 'DOI:'
then  'DO'
else substr(rx, 1,10)
end,
substr(ltrim (rx, 'abcdefghijklmnopqrstuwxyvzABCDEFGHIJKLMNOPQRSTUWXYVZ'),2),
e.id
from alfa a, entry e
where e.old_id = a.id
and e.old_id not like 'PRX%'
and a.term is null
and a.rx is not null
)
;

