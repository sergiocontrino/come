--  SET DOC OFF
--  *************************************************************
--
--  Purpose: create come schema
--
--  Usage:   sqlplus username/password @skeleton.sql
--
--  Note:    a first working schema.
--
--  *************************************************************

create table entry
(
id              serial primary key,      --NOT NULL,
name            varchar(200)   NOT NULL,
type            varchar(1),     --NOT NULL,
old_id          varchar(10)    NOT NULL,
coordination    varchar(10),
formula         varchar(5) ,
timestamp       timestamp      DEFAULT current_timestamp
)
;



create table instance
(
id_instance    serial primary key,     -- NOT NULL,
instance       varchar(300)   NOT NULL,             
id             integer,     -- NOT NULL,
species        varchar(100),             --only for prx, usa taxid?    
state          varchar(50),              --only prx 
centre         varchar(20),              --only prx
timestamp       timestamp      DEFAULT current_timestamp
)
;

create table db_xref
(
id_dbx         serial primary key,
id_come        integer,   -- NOT NULL,    -- either id  or id_instance
dbcode         varchar(10)  NOT NULL,
dbid           varchar(30)  NOT NULL,
timestamp       timestamp      DEFAULT current_timestamp
)
;

create table coordination
(
coorcode        varchar(5)   NOT NULL,
coordination    varchar(10)  NOT NULL,
description     varchar(100) NOT NULL,
IUPAC           varchar(1)   default 'Y'   NOT NULL
)
;
-- polyhedral+"-"+dimension


create table database
(
dbcode        varchar(2)    NOT NULL,
dbabbrev      varchar(10)   NOT NULL,
dbname        varchar(100),
dblink        varchar(100),
link_end      varchar(5)
)
;

/* prob not needed
create table BIM
(
id              integer      NOT NULL,
id_brick        integer       NOT NULL,
orderin         integer       NOT NULL,
type            varchar(3),
coordination    varchar(5),
timestamp       timestamp      DEFAULT current_timestamp
)
;
*/

create table bim_lego
(
id_brick       serial primary key,
symbol         varchar(30)  NOT NULL,
brick_type     varchar(2)   NOT NULL,    --{Metal, Ligand, Molecule}
description    varchar(100) NOT NULL,
alt_descr      varchar(50),
timestamp       timestamp      DEFAULT current_timestamp
)
;

-- ====================================

create sequence seq_ids;

-- =====================================


-- 
-- this is to load preliminary data for come
--

create table alfa
(
id              varchar(10),
name            varchar(250),
term            varchar(250),
instance        varchar(100),
dbx             varchar(80),
rx              varchar(80),
coord           varchar(7),
specie          varchar(50),
state           varchar(80),
centre          varchar(20)
)
;

-- kid = kirill id..
create table equivalence
(
kid              varchar(10),
code             varchar(20)
)
;

create table rel
-- old_id and equiv
(
parent            varchar(10),
child             varchar(20)
)
;

create table relations
-- to be filled with id-id relationships
(
id                integer NOT NULL,
parent            integer NOT NULL,
type              varchar(20),
PtoC              varchar(20)
)
;

/* to do if convenient 9changes to relations.
-- note that at the moment you need at least a varchar(2) to properly fill
relations)
create table cv_rel
(
code              integer,
type              varchar(20)
)
;
*/


-- path enumeration
/* seems obsolete sc 30/06/08
create table path
(
id integer not null,
child integer not null,
len integer check(len >= 0)
)
;
*/


create table path
(
path integer not null,
id integer not null,
rel varchar(20),
child integer not null,
len integer check(len >= 0)
)
;



-- ====================================
/*
create index i_path_path
on path (path)
;

create index i_path_id
on path (id)
;

create index pathfili
on path (child)
;
*/


-- =====================================
