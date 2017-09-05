#lang info
(define collection "counter-string")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/counter-string.scrbl" ())))
(define pkg-desc "Self-describing strings for testing")
(define version "1.0")
(define pkg-authors '("Christopher D. Walborn"))
