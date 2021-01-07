COPY alfa FROM '/home/contrino/come/data/alfa.ld'
with delimiter as '%'
null as '-'
;

COPY equivalence FROM '/home/contrino/come/data/eq.ld'
with delimiter as ' '
;

COPY rel FROM '/home/contrino/come/data/rel.ld'
with delimiter as ' '
;




--bimmol--348-361
insert into entry (old_id, name, coordination)
(select distinct id, name, coord 
from alfa
where name is not null)
;

--prx--770-798
insert into entry (old_id, name)
(select distinct id, term 
from alfa
where name is null
and term is not null)
;


-- prx NB many entry same instance!!--529 --551
-- es: p101 e p292

insert into instance (instance, id, species, state, centre)
( 
select distinct a.instance, e.id, a.specie, a.state, a.centre 
from alfa a, entry e
where e.old_id = a.id
and a.name is null
and a.instance is not null
)
;
 
-- molbim--(516--??) 150
insert into instance (instance, id)
( select distinct a.term, e.id 
from alfa a, entry e
where e.old_id = a.id
and a.term is not null
and a.name is not null
and instance is null
)
;


\i dbxfiller.sql

\i relations.sql


