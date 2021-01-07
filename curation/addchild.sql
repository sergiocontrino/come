--  SET DOC OFF
--  ****************************************************************************
--
--  Purpose:    
--
--  Usage:      sqlplus username/password @skeleton.sql
--
--
--  $Source$
--  $Date$
--  $Author$
--  ____________________________________________________________________________
--  
--  $Log$
--  ****************************************************************************

set verify off

prompt
prompt Please enter relation [binds, contains, includes]:
accept rel
--prompt
--prompt Please enter child id:
--accept chi

declare
par number(15);
pro number(15);
 
begin
select id into par from come.entry where old_id = upper('&1');
select id into pro from come.entry where old_id = upper('&2');

insert into come.relations (id, parent, ptoc)
values (pro, par, '&rel')  
;

update come.relations
set type = decode ( ptoc, 'binds', 'isBoundTo',
                          'contains','isPartOf',
                          'includes','isKindOf',
                    null)
where type is null
and parent = par 
;

end;
/

@show &1

set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
