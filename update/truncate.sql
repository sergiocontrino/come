truncate table DB_XREF ;
truncate table ENTRY ;
truncate table INSTANCE ;
truncate table PATH ;
truncate table RELATIONS ;
drop sequence SEQ_IDS ;
create sequence seq_ids;


alter table entry
drop constraint pk_entry 
;
 
alter table instance 
drop constraint pk_instance
;

alter table db_xref 
drop constraint pk_xref
;

alter table database 
drop constraint pk_db
;

alter table coordination
drop constraint pk_coordination
;
