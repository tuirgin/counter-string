#lang scribble/manual
@require[@for-label[counter-string
                    racket/base
                    racket/string]
         racket/sandbox
         scribble/example]

@title{Counter-String: Self-Describing Strings}
@author{Christopher D. Walborn}

@margin-note{James Bach describes counter strings and offeres his PerlClip
 program on his blog:
 @hyperlink["http://www.satisfice.com/blog/archives/22"]{Counterstrings:
  Self-Describing Test Data}. PerlClip is still available as both a Perl script
 and a compiled Windows executable, but it is not suitable for command line usage
 where the use of standard output is expected.}

Counter strings are self-documenting strings consisting of character position
references and markers. Each numeric character position reference indicates the
string length at the following marker. The primary application for counter
strings is in testing input to text fields. Given the nature of counter strings
it is immediately apparent when and where truncation has occurred on a string.

Take, for example, this 64-character counter string:

@codeblock{"*3*5*7*10*13*16*19*22*25*28*31*34*37*40*43*46*49*52*55*58*61*64*"}

If it had been truncated at 32 characters, it would appear like this:

@codeblock{"*3*5*7*10*13*16*19*22*25*28*31*3"}

@section{Library}
@defmodule[counter-string]
@defproc[(counter-string [length exact-positive-integer? 256]
                         [#:mark marker non-empty-string? "*"])
         string?]{
 Returns a counter string of @racket[length] characters,
 where character position indicators are terminated by @racket[marker].}

@(define counter-string-evaluator
   (parameterize ([sandbox-output 'string]
                  [sandbox-error-output 'string])
     (make-evaluator 'racket '(require counter-string))))

@examples[#:eval counter-string-evaluator
          (substring (counter-string) 230)
          (counter-string 30)
          (substring (counter-string #:mark "^") 0 30)]

A multi-character @racket[marker] is supported. The position indicated is that
of the final character within the marker string.

@examples[#:label #f #:eval counter-string-evaluator
          (code:comment @#,elem{Just... no. But go ahead if you must.})
          (counter-string 24 #:mark "<(ಠ_ಠ)>")]

@section{Command Line Tool}

The command line tool---@tt{counter-string.rkt}---is found in the collection's
@tt{bin} directory and is simply a wrapper around the @racket[counter-string]
function.

@verbatim[#:indent 5]|{
           counter-string [ <option> ... ] [<length>]

           where <length> is a positive integer : Default: 256.
           where <option> is one of
           --marker <marker>, -m <marker> : Default: *
           Specify the marker character.
           --help, -h : Show this help
           -- : Do not treat any remaining argument as a switch (at this level)
           Multiple single-letter switches can be combined after one `-'; for
           example: `-h-' is the same as `-h --'

           Creates a <length> characters long counter string. Each integer
           indicates the character position of the following <marker>.

           Ex. 24 character counter-string: *3*5*7*9*12*15*18*21*24*
           }|

@section{A really dumb GUI}

For the sake of those with CLI allergies, I threw together a GUI:
@tt{counter-string-gui.rkt}. It is found in the collection's @tt{bin} directory.