select timestamp from proteomes.cromosptr  
where gid=12777
group by timestamp 
having max(timestamp)
;


select rowid, gid, acc 
from cromosptr
where gid=12777
;

delete from cromosptr where rowid='AAAsxoAMAAAAcTZAAM';

select rowid, gid, acc 
from cromosptr
where gid=13897
;
delete from cromosptr where rowid='AAAsxoABeAACV5+AA4';
delete from cromosptr where rowid='AAAsxoABeAACV5+AA3';



