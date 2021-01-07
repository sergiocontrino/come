CREATE OR REPLACE PROCEDURE fillpath
IS

begin
declare 
len        number(15) := 1;
oldsize    number(15) := 0;
newsize    number(15) := 0;
     
CURSOR c_get_level (level number) IS
SELECT p.path, p.id, p.rel, p.child
FROM path p
WHERE len = level
order by path
;

CURSOR c_get_child (child number) IS
select parent, ptoc, id
from relations
where parent = child
;

CURSOR c_get_parent (child number) IS
select parent, ptoc, id
from relations
where id = child
;

CURSOR c_get_path (pathid number, level number) IS
select id, rel, child, len 
from path
where path = pathid
and len = level
;

    level_record c_get_level%ROWTYPE;
    child_record c_get_child%ROWTYPE;
    parent_record c_get_parent%ROWTYPE;
    path_record c_get_path%ROWTYPE;

pathid   number(9);
prev_path   number(9);
achild  number(9);
rows number(9);
level number(5);
alevel number(5);
path_incr number (3);
--first number(1);
first_par number(1);
	stampa number (5);
new_path number (9);
new_end number (9);
path number (9);
start_path number (9);
end_path number (9);



begin

dbms_output.enable ( 1000000 );

--dbms_output.put_line ( 'starting!!' );
dbms_output.put_line ( 'new: '||newsize||' -- old: '||oldsize );


select count (*)  into newsize from path;
dbms_output.put_line ( 'new: '||newsize||' len: '|| len);

level := 1;

while (oldsize < newsize) loop

   rows := 0;
  -- prev_path:= 0;

   FOR level_record IN c_get_level(level) LOOP

--      first :=1;
   prev_path:= 0;

   FOR child_record IN c_get_child(level_record.child) LOOP

--      if first = 1 then
      if prev_path != level_record.path then
         pathid := level_record.path;
      else
      -- 
      -- let's fill parents node with this path

         -- get next path id.
	 select max (path) + 1 into pathid from path;
	 achild := child_record.parent;
	 alevel := level;

         path_incr:= 0;
         new_path := 0; -- in case there is no parent..

         -- for all the parents for this id insert the path(s) going through the id	
         -- the first get the same path id of the id, the following get new paths
    	 FOR parent_record IN c_get_parent(achild) LOOP
            new_path := pathid + path_incr;
       
            insert into path (path, id, rel, child, len)
	    values (new_path, parent_record.parent, parent_record.ptoc, 
	    achild, alevel);

            path_incr := path_incr +1;
	 end loop;
	 alevel := alevel -1;

	start_path := pathid;
	end_path := new_path;

         -- now we need to fill all ancestors with the added paths
         -- note that if there are more than 1 parents you need to add new paths....

	 while (alevel >0 ) loop
         <<aldo>>
--         FOR path IN pathid..new_path LOOP
         FOR path IN start_path..end_path LOOP
            FOR path_record IN c_get_path(path, alevel+1) LOOP
               first_par := 1;
               FOR parent_record IN c_get_parent(path_record.id) LOOP
                  if first_par = 1 then
                     insert into path (path, id, rel, child, len)
	             values (path, parent_record.parent, parent_record.ptoc, 
		     path_record.id, alevel);
                  else
                     insert into path (path, id, rel, child, len)
	             values (path + path_incr, parent_record.parent, parent_record.ptoc, 
		     path_record.id, alevel);

                     stampa := path + path_incr;
                     dbms_output.put_line ( '** '||stampa||' '||parent_record.parent||' '||alevel||' '|| start_path);

                     new_end := path + path_incr;
                     path_incr := path_incr + 1;
                  end if;
               first_par := 0;
	       end loop;
            end loop;
            -- if we added more paths then loop again
            if new_end > end_path then 
               start_path := end_path +1;
               end_path   := new_end;
               dbms_output.put_line ( 'aa '||start_path||' '||end_path||'--' );
               GOTO aldo; 
            end if;
         end loop;

         alevel:= alevel -1;
         start_path := pathid;


	 end loop; --while

	-- .. and here it finishes
      end if;

      -- insert new level

      insert into path(path, id, rel, child, len)
      values (pathid, child_record.parent, child_record.ptoc,
      child_record.id, level+ 1);

      --first:=0;
      prev_path:= level_record.path;
		
   end loop;

   rows := rows+1;

   IF rows MOD 1000 = 0 THEN
      COMMIT;
   END IF;

   END LOOP;

--dbms_output.put_line ( 'inserted '||rows||' rows.' );
dbms_output.put_line ( 'insert: '||level);

level := level +1;
--first:=1;
oldsize:= newsize;
select count (*)  into newsize from path;

--dbms_output.put_line ( 'new: '||newsize||' ++ old: '||oldsize );

exit when level > 100;

end loop;
end;
end;
/
SHOW ERRORS;

