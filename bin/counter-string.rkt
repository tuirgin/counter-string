#!/usr/bin/env racket
#lang racket/base

(require counter-string
         racket/cmdline
         racket/format)

(define cs-length (make-parameter 256))
(define cs-marker (make-parameter "*"))

(module+ main
  (command-line
   #:program "counter-string"
   #:usage-help "\n where <length> is a positive integer : Default: 256."
   #:once-each
   [("--marker" "-m")
    marker
    ("Default: *" "Specify the marker character.")
    (cs-marker marker)]
   #:ps ""
   "Creates a <length> characters long counter string. Each integer"
   "indicates the character position of the following <marker>.\n"
   "Ex. 24 character counter-string: *3*5*7*9*12*15*18*21*24*\n"
   #:args ([length (cs-length)]) (cs-length length))
  (printf "~a~n" (counter-string (cs-length) #:mark (cs-marker))))

