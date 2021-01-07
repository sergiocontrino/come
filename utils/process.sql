column process format a10
column user format a10
column xuser format a10
column program format a20

column sid format 99999
column spid format a8
column status format a8


SELECT s.sid, p.spid, NVL(s.process, 0) "process", s.status,
NVL(s.username, '-') "user", NVL(s.osuser, '-') "xuser", NVL(s.program, '-') "program"
FROM v$process p, v$session s 
WHERE s.paddr = p.addr AND s.type = 'USER'
ORDER BY s.status, s.username, s.osuser
;

