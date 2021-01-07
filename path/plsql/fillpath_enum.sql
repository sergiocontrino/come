CREATE OR REPLACE PROCEDURE fillpath_en
IS

/*
to fill the path_enum table
from joe celko's sql for smarties
*/


begin
declare 
len        number(15) := 1;
oldsize    number(15) := 0;
newsize    number(15) := 0;

begin

dbms_output.put_line ( 'starting!!' );
dbms_output.put_line ( 'new: '||newsize||' -- old: '||oldsize );

/*
newsize := (select count (*) from path_enum);
*/

select count (*)  into newsize from path_enum;
dbms_output.put_line ( 'new: '||newsize||' len: '|| len);

while (oldsize < newsize) loop
insert into path_enum
select distinct p1.id, b1.id, (p1.len +1) 
from path_enum p1, relations b1
where b1.parent = p1.child
and not exists
(select * from path_enum p3
where p1.id = p3.id
and b1.id = p3.child)
and p1.len=len
;

dbms_output.put_line ( 'insert: '||len);
len := len +1;

oldsize:= newsize;
select count (*)  into newsize from path_enum;
dbms_output.put_line ( 'new: '||newsize||' ++ old: '||oldsize );

exit when len > 1000;

end loop;
end;
end;
/
SHOW ERRORS;
