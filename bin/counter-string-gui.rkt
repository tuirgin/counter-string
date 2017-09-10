#lang racket/gui

(require counter-string)

(define frame (new frame% [label "Counter-String"] [width 400]))

(define message (new message%
                     [parent frame]
                     [label "Enter length and marker, then click “Go!”"]))

(define input-panel (new horizontal-panel% [parent frame]))

(define length-field (new text-field%
                          [parent input-panel]
                          [label "String length:"]
                          [init-value "256"]
                          [min-width 125]))

(define marker-field (new text-field%
                          [parent input-panel]
                          [label "Marker:"]
                          [init-value "*"]
                          [min-width 80]))
(define go-button
  (new button%
       [parent input-panel]
       [label "Go!"]
       [callback
        (lambda (b e)
          (define cs (counter-string (send length-field get-value)
                                     #:mark (send marker-field get-value)))
          (send text erase)
          (send the-clipboard set-clipboard-string cs (send e get-time-stamp))
          (send text insert cs))]))

(define editor-canvas (new editor-canvas% [parent frame]
                           [label "Counter-string"]
                           [min-height 150]))

(define status (new message%
                    [parent frame]
                    [label "The string will be copied to the clipboard."]
                    [auto-resize #t]))

(define text (new text% [auto-wrap #t]))
(send editor-canvas set-editor text)

(send frame show #t)
