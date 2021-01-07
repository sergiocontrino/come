-- path 
create table path
(
path number(15)  ,--not null,
id   number(15)  not null,
rel  varchar2(15),
child number(15) not null,
len   number(15) check(len >= 0)
)
storage (initial 1M next 1M maxextents 99 pctincrease 0 )
;

drop sequence SEQ_PATH;

create sequence SEQ_PATH;

--len 1
insert into path (path, id, rel, child, len)
select seq_path.nextval, r.parent, r.ptoc, r.id, 1
from relations r, entry e
where r.parent = e.id
and e.name = 'complex protein' --root
;



create index path_path on path
(
path
)
storage (INITIAL 100K NEXT 100K)
;

/*
create index path_id on path
(
id
)
storage (INITIAL 100K NEXT 100K)
;
*/
