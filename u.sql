SELECT distinct l.name, l.id, l.coordination, c.description, l.formula 
FROM entry l LEFT JOIN coordination c 
ON l.coordination = c.coordination 
WHERE l.old_id = upper('bim000205');
