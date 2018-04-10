(in-package :mu-cl-resources)

(defparameter *cache-count-queries* nil)
(defparameter *include-count-in-paginated-responses* t
  "when non-nil, all paginated listings will contain the number
   of responses in the result object's meta.")

(read-domain-file "master-mandaat-domain.lisp")
(read-domain-file "slave-besluit-domain.lisp")

(define-resource export ()
  :class (s-prefix "export:Export")
  :properties `((:filename :string ,(s-prefix "nfo:filename"))
                (:format :string ,(s-prefix "dct:format"))
                (:filesize :number ,(s-prefix "nfo:fileSize"))
                (:created :datetime ,(s-prefix "dct:created")))
  :resource-base (s-url "http://data.lblod.info/id/exports/")
  :on-path "exports")
