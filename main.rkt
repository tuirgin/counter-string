#lang racket/base

(require racket/format
         (only-in racket/string non-empty-string?)
         (only-in srfi/13 string-reverse))

(provide counter-string)

(module+ test
  (require rackunit))

(define DEFAULT-LENGTH 256)
(define DEFAULT-MARKER "*")

(define cs-length
  (make-parameter
   DEFAULT-LENGTH
   (lambda (l)
     (cond [(and (string? l) (exact-positive-integer? (string->number l))) (string->number l)]
           [(exact-positive-integer? l) l]
           [else
            (raise-user-error "The length must be specified as a positive integer.\n<length>:" l)]))))

(define cs-marker
  (make-parameter
   DEFAULT-MARKER
   (lambda (m)
     (cond [(non-empty-string? m) m]
           [else
            (raise-user-error
             "The marker symbol must be a string of one or more characters.\n<marker>:"
             m)]))))

(define (counter-string [length DEFAULT-LENGTH] #:mark [marker DEFAULT-MARKER])
  (unless (equal? length (cs-length)) (cs-length length))
  (unless (equal? marker (cs-marker)) (cs-marker marker))
  (build-counter-string))

(define (build-counter-string [count (cs-length)] [acc ""])
  (cond [(almost-full? count acc) (finish-counter-string acc)]
        [else (append-count+mark count acc)]))

(module+ test
  (check-exn exn:fail:user? (lambda () (counter-string 0)))
  (check-exn exn:fail:user? (lambda () (counter-string "0")))
  (check-exn exn:fail:user? (lambda () (counter-string "foo")))
  (check-equal? (counter-string 1) "*")
  (check-equal? (counter-string 2) "2*")
  (check-equal? (counter-string 3) "*3*")
  (check-equal? (string-length (counter-string 10000)) 10000)
  (check-equal? (counter-string 10 #:mark ">") ">3>5>7>10>")
  (check-equal? (counter-string 2 #:mark "@#$%") "@@")
  (check-equal? (counter-string 10 #:mark "@#$%") "@@@@10@#$%"))

(define (finish-counter-string acc)
  (string-reverse
   (~a acc (make-string
            (- (cs-length) (string-length acc))
            (string-ref (cs-marker) 0)))))

(define (append-count+mark count acc)
  (define count-string (number->string count))
  (build-counter-string
   (- count
      (string-length count-string)
      (string-length (cs-marker)))
   (string-append acc (string-reverse (cs-marker)) (string-reverse count-string))))

(define (almost-full? count str)
  (define string+count+mark-length (+ (string-length str)
                                      (string-length (number->string count))
                                      (string-length (cs-marker))))
  (> string+count+mark-length (cs-length)))

(module+ test
  (cs-marker "*")
  (cs-length 1)
  (check-equal? (almost-full? 1 "") #t)
  (cs-length 2)
  (check-equal? (almost-full? 2 "") #f)
  (check-equal? (almost-full? 0 "*2") #t)
  (cs-length 5)
  (check-equal? (almost-full? 3 "*5") #f)
  (check-equal? (almost-full? 1 "*5*3") #t))
