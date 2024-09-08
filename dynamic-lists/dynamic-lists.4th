\ These words don't have any sanity checks and will crash the system
\ if you try to go under 0 elements.
\ I feel indifer to what should happen, so I'm keeping them like this.
\ If you with them to handle it differently, you are encuraged to edit
\ them as much as you like

\ Words can be easily modified to use items of different size.
\ The base list% is usable for any type of data.


begin-structure list%
  field: list-len
  field: list-ptr
end-structure

: new-list64 ( n -- a ) \ len
  \ list
  list% allocate throw
 
  \ contents
  2dup list-len !
  swap cells allocate throw
  over list-ptr !
;

: new-list64-fill ( n* -- a ) \ list of values ended by length
  dup new-list64              \ example: 14 6 42 3 new-list64-fill

  swap
  dup 0<> if
    0 do
      swap
      over list-ptr @ i cells + !
    loop
  then
;

: list64-resize { n a -- } \ delta list64
  a list-ptr dup @
  a list-len dup @ n + 
  \ ptr-adr ptr len-adr new-len

  dup rot !
  cells resize throw
   
  swap !
;

: list64-append ( n a -- )
  1 over list64-resize
  dup list-len @ 1- cells
  swap list-ptr @ + ! 
;

: list64-pop ( a -- n )
  dup list-ptr @
  over list-len @ 1- cells + @
  -1 rot list64-resize
;
