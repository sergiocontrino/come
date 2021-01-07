From kirill@ebi.ac.uk Thu Jun 14 11:58:43 2001
Date: Thu, 14 Jun 2001 11:55:48 +0100
From: Kirill Degtyarenko <kirill@ebi.ac.uk>
To: Sergio Contrino <contrino@ebi.ac.uk>
Subject: more and more complete list of attributes

BIM:

substructure
substructure attribute:   id       REQUIRED
substructure attribute:   dbxref
substructure attribute:   lref

term
term attribute:           dbxref
term attribute:           lref
term attribute:           value

bim
bim attribute:            coordination

MOL:

substructure
substructure attribute:   id       REQUIRED
substructure attribute:   value    REQUIRED

term
term attribute:           value    REQUIRED
term attribute:           dbxref
term attribute:           lref

PRX:

term
term attribute:           id       REQUIRED
term attribute:           value    REQUIRED
term attribute:           dbxref
term attribute:           lref

instance
instance attribute:       value    REQUIRED
instance attribute:       species  REQUIRED
instance attribute:       dbxref
instance attribute:       lref
instance attribute:       state
instance attribute:       centre
