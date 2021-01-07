SELECT distinct l.name, l.id, l.coordination, c.description
FROM come.entry l, come.coordination c 
WHERE l.old_id like 'BIM%' 
and l.coordination = c.coordination (+)
ORDER BY l.id;
