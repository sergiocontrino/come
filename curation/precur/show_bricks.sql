column description format a40
column alt_descr format a16
column symbol format a15
column id_brick format 99 head id
column brick_type format a2 head ty

select id_brick, brick_type, symbol, description, alt_descr
from bim_lego
;
