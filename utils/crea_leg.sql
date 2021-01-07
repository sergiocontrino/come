create view legenda
as 
select 
e.id "ID", e.old_id "KID", i.id_instance "INST"
from entry e, instance i
where
e.id = i.id
union
select
e.id "ID", e.old_id "KID", null "INST"
from entry e
where e.id not in
(select id from instance)
;




--select
--e.id "ID", e.old_id "KID", null "INST"
--from entry e
--where not exists
--(select id from instance)
--;

