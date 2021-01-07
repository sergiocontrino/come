SELECT distinct e.name, e.id 
FROM entry e
WHERE e.old_id = ? ");

SELECT distinct p.path
FROM path p
WHERE p.id = &1;



SELECT distinct p.id, e.old_id, e.name, p.rel, p.child, p.len
FROM path p, entry e
WHERE e.id = p.id 
and p.path = &1
order by len;
