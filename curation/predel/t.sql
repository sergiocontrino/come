declare
par number(15);
pro number(15);
 
begin
dbms_output.enable ( 1000000 );

select id into par from come.entry where old_id ='&1';
select id into pro from come.entry where old_id ='&2';

DBMS_OUTPUT.PUT_LINE('par: ' || par); 
DBMS_OUTPUT.PUT_LINE('pro: ' || pro); 

insert into come.relations (id, parent, ptoc)
values (pro, par, 'ugo')  
;

end;
/
