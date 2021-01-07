-- relationships -- 1578 (but 1596 rel..?) 1633/1654 (some duplications (BP))

insert into relations (id, parent, type)
(-- for prx-molbim
select a.id, b.id, 
--a.old_id, b.old_id,
substr(a.old_id,1,1)||substr(b.old_id,1,1)
from entry a, entry b, rel c
where b.old_id = c.parent
and a.old_id = c.child
--)
union
--(
-- prx-prx
select a.id, b.id, 
--a.old_id, b.old_id, 
'isKindOf'
from entry a, entry b, rel c, equivalence d
where b.old_id = c.parent
and c.child = d.code
and a.old_id = d.kid
)
;

--328
update relations
set type = 'isPartOf' 
where type = 'BP'
;

--1
update relations
set type = 'isPartOf' 
where type = 'MB'
;

--90
update relations
set type = 'isBoundTo' 
where type = 'MP'
;


-- new!!
update relations
set type = 'isKindOf' 
where type = 'BB'
and parent in (select id from entry where name like '%|%')
;

--4 93
update relations
set type = 'isKindOf' 
where type = 'BB'
and parent in (select id from entry where name like '%*')
;


--165 76
update relations
set type = 'isPartOf' 
where type = 'BB'
;

--6  62
update relations
set type = 'isKindOf' 
where type = 'MM'
and parent in (select id from entry where name like '%*')
;

--58  2
update relations
set type = 'isPartOf' 
where type = 'MM'
;

--981
update relations
set ptoc = 'includes' 
where type = 'isKindOf'
;

-- 155
-- update relations
-- set ptoc = 'includes*' 
-- where type = 'isKindOf*'
-- ;

--407
update relations
set ptoc = 'contains' 
where type = 'isPartOf'
;

--90
update relations
set ptoc = 'binds' 
where type = 'isBoundTo'
;


/* see path.sql now
-- first filling for path (ln=0 and ln=1)

--len=0  --1178
insert into path (id, child, len)
select distinct id , id , 0 from relations;


--len=1  --1633
insert into path (id, child, len)
select distinct parent, id , 1 from relations;
*/