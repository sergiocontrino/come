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
prompt Please enter parent id:
accept par
prompt
prompt Please enter relation [binds, contains, includes]:
accept rel
prompt
prompt Please enter child id:
accept chi

select old_id into v_p where 

insert into come.relations (id, parent, ptoc)
values ('&chi', '&par', '&rel')  
;

update come.relations
set type = decode ( ptoc, 'binds', 'isBoundTo',
                          'contains','isPartOf',
                          'includes','isKindOf',
                    null)
where type is null;


set feedback off
prompt
prompt use    commit    to save the changes
prompt or   rollback    to discard them
prompt NB       exit    will commit before exiting
prompt
set feedback on
