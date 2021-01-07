declare

CURSOR p_cursor IS
SELECT distinct e.old_id, i.instance 
FROM  instance i, entry e
where i.id=e.id
;

p_record p_cursor%ROWTYPE;
rows     number(9);

  BEGIN
    rows := 0;	
    FOR p_record IN p_cursor 

LOOP

update instance set (species, state, centre) = 
(select specie, state, centre
from alfa 
where id=p_record.old_id
and instance=p_record.instance
);

	rows := rows + 1;
--	dbms_output.put_line ( 'Inserted '||rows||' ids in entry' );

    END LOOP;
    dbms_output.put_line ( 'Inserted '||rows||' ids in entry' );
end;
/
