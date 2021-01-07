-- path enumeration
create table path_enum
(
id number(15) not null,
child number(15) not null,
len number(15) check(len >= 0)
)
storage (initial 1M next 1M maxextents 99 pctincrease 0 )
;

--len=1
insert into path_enum (id, child, len)
select distinct parent, id, 1 from relations;


