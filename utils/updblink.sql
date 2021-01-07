DBCODE DBABBREV
------ ------------------------------
C      Compound
EC     EC
GO     GO
IP     InterPro
P      PDB
PH     PDBHet
R      RESID
S      SPTr
TN     TrEMBLnew
ME     MEROPS
ML     MedLine
PM     PubMed
CA     CAS

insert into database (dbcode, dbabbrev, dbname,dblink)
values ('DO', 'DOI', 'DOI', 'http://dx.doi.org/')
;


update database 
set dbabbrev = 'UniProt'
where dbcode = 'S'
;


set escape on

update database 
set dblink = 'http://www.genome.jp/dbget-bin/www_bget?cpd:',
LINK_END = null
where dbcode = 'C'
;

update database 
set dblink = 'http://www.ebi.uniprot.org/entry/'
where dbcode = 'S'
;
update database 
set link_end =null
where dbcode = 'S'
;

update database 
set dblink = 'http://www.ebi.ac.uk/intenz/query?cmd=SearchEC\&ec=',
LINK_END = null
where dbcode = 'EC'
;

update database 
set dbabbrev = 'chemPDB'
where dbcode = 'PH'
;



update database 
set dblink = 'http://www.ebi.ac.uk/msd-srv/chempdb/cgi-bin/cgi.pl?FUNCTION=getByCode\&CODE='
where dbcode = 'PH'
;

update database 
set dblink = 'http://srs.ebi.ac.uk/srsbin/cgi-bin/wgetz?-id+COMe+-view+MedlineFull+[MEDLINE:',
LINK_END = ']'
where dbcode = 'PM'
;

update database 
set dblink = 'http://srs.ebi.ac.uk/srsbin/cgi-bin/wgetz?-id+COMe+-view+MedlineFull+[MEDLINE-MID:',
LINK_END = ']'
where dbcode = 'ML'
;

update database 
set dblink = 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve\&db=PubMed\&dopt=Abstract\&list_uids=',
LINK_END = ''
where dbcode = 'ML'
;

update database 
set dblink = 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve\&db=PubMed\&dopt=Abstract\&list_uids=',
LINK_END = ''
where dbcode = 'PM'
;

set escape on

