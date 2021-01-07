--  SET DOC OFF
--  ****************************************************************************--
--  Purpose:    
--
--  Usage:      sqlplus username/password @skeleton.sql
--
--
--  $Source$
--  $Date$
--  $Author$
--  ____________________________________________________________________________--  
--  $Log$
--  ****************************************************************************

set verify off

prompt
prompt Please enter relation [isBoundTo, isPartOf, isKindOf]:
accept rel

declare
par number(15);
pro number(15);
 
begin

select id into pro from come.entry where old_id = upper('&1');
select id into par from come.entry where old_id = upper('&2');

insert into come.relations (id, parent, type)
values (pro, par, '&rel')  
;

update come.relations
set ptoc = decode ( type, 'binds', 'isBoundTo',
                          'contains','isPartOf',
                          'includes','isKindOf',
                    null)
where ptoc is null
and id = pro 
;

end;

@show &1

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
