--  SET DOC OFF
--  ****************************************************************************
--
--  Purpose: to build dot files for graphviz
--
--  Usage:   sqlplus username/password @buildot {PRX|MOL|BIM|...}
--
--  Note:    build a sql script (get.arg) that call the script upath for each
--           entry involved. run the get script. rm the get script  
--
--  $Source: /homes/contrino/come/gv/sql/RCS/buildot.sql,v $
--  $Date: 2003/12/03 14:34:28 $
--  $Author: contrino $
--  ____________________________________________________________________________
--  
--  $Log: buildot.sql,v $
--  Revision 1.2  2003/12/03 14:34:28  contrino
--  *** empty log message ***
--
--  Revision 1.1  2003/10/15 15:43:29  contrino
--  Initial revision
--  ****************************************************************************

set pages 0
set feedback off
set verify off

--set timing on

set term off

spool get.&1

select '@upath '||old_id
from entry
where old_id like '&1%'
;

spool off

set term on;

@get.&1

set feedback on;


prompt dot file(s) ready!!

!rm get.&1

exit;