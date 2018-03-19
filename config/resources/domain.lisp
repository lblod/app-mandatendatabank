(in-package :mu-cl-resources)

(defparameter *cache-count-queries* nil)
(defparameter *include-count-in-paginated-responses* t
  "when non-nil, all paginated listings will contain the number
   of responses in the result object's meta.")

(read-domain-file "master-mandaat-domain.lisp")
(read-domain-file "slave-besluit-domain.lisp")
