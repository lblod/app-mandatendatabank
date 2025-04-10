;;;;;;;;;;;;;;;;;;;
;;; delta messenger
(in-package :delta-messenger)

(add-delta-messenger "http://deltanotifier/")

;;;;;;;;;;;;;;;;;
;;; configuration
(in-package :client)
(setf *backend* "http://virtuoso:8890/sparql")
(setf dexador.util:*default-connect-timeout* 60)
(setf dexador.util:*default-read-timeout* 60)

(in-package :server)
(setf *log-incoming-requests-p* nil)

;;;;;;;;;;;;;;;;;
;;; access rights
(in-package :acl)

(define-prefixes
  :besluit "http://data.vlaanderen.be/ns/besluit#"
  :ext "http://mu.semte.ch/vocabularies/ext/"
  :leidinggevenden "http://data.lblod.info/vocabularies/leidinggevenden/"
  :locn "http://www.w3.org/ns/locn#"
  :mandaat "http://data.vlaanderen.be/ns/mandaat#"
  :nfo "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
  :org "http://www.w3.org/ns/org#"
  :person "http://www.w3.org/ns/person#"
  :persoon "http://data.vlaanderen.be/ns/persoon#"
  :prov "http://www.w3.org/ns/prov#"
  :schema "http://schema.org/")

(define-graph public ("http://mu.semte.ch/graphs/public")
  ("besluit:Bestuurseenheid" -> _)
  ("besluit:Bestuursorgaan" -> _)
  ("ext:BeleidsdomeinCode" -> _)
  ("ext:BestuurseenheidClassificatieCode" -> _)
  ("ext:BestuursfunctieCode" -> _)
  ("ext:BestuursorgaanClassificatieCode" -> _)
  ("ext:GeslachtCode" -> _)
  ("ext:MandatarisStatusCode" -> _)
  ("ext:SyncTask" -> _)
  ("mandaat:Fractie" -> _)
  ("mandaat:Mandaat" -> _)
  ("mandaat:Mandataris" -> _)
  ("mandaat:TijdsgebondenEntiteit" -> _)
  ("nfo:FileDataObject" -> _)
  ("org:Membership" -> _)
  ("org:Organization" -> _)
  ("org:Post" -> _)
  ("org:Role" -> _)
  ("org:Site" -> _)
  ("person:Person" -> _)
  ("persoon:Geboorte" -> _)
  ("prov:Location" -> _)
  ("schema:PostalAddress" -> _))

(supply-allowed-group "public")

(grant (read)
  :to-graph (public)
  :for-allowed-group "public")
