declare

CURSOR p_cursor IS
SELECT id, coord  
FROM  alfa
where coord is not null
;

p_record p_cursor%ROWTYPE;
rows     number(9);

  BEGIN
    rows := 0;	
    FOR p_record IN p_cursor 

LOOP

update entry set coordination = p_record.coord 
where old_id=p_record.id;

	rows := rows + 1;
--	dbms_output.put_line ( 'Inserted '||rows||' ids in entry' );

    END LOOP;
    dbms_output.put_line ( 'Inserted '||rows||' ids in entry' );
end;
/
